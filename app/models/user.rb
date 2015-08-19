class User < ActiveRecord::Base

  using_access_control
  
  scope :with_no_period, {
    joins:      'LEFT JOIN periods_users ON users.id = periods_users.user_id',
    conditions: 'periods_users.user_id IS NULL',
    select:     'DISTINCT users.*'
  }
  
  searches :first_name, :last_name

  attr_accessible :email, :password, :password_confirmation, :first_name,
    :last_name, :name, as: [:developer, :superintendent, :principal, :secretary, :teacher]
  attr_accessible :school_id, as: [:developer, :superintendent]
  attr_accessible :period_ids, as: [:developer, :superintendent, :principal, :secretary]
  attr_accessible :role_id, as: :developer

  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
    c.logged_in_timeout = 3.hours
  end
  
  AUTHLOGIC_MAGIC_COLUMNS = %w(login_count failed_login_count 
                                last_login_at current_login_at
                                current_login_ip last_login_ip
                                last_request_at perishable_token)

  belongs_to :school
  has_one :district, through: :school
  belongs_to :role
  has_and_belongs_to_many :periods, extend: WithTermExtension
  has_many :import_data
  has_many :export_data
  has_many :export_list_items
  has_many :export_list_students, through: :export_list_items, source: :student
  has_many :test_scores, through: :students
  
  after_initialize :associate_students
  before_save :update_appropriate_timestamps
  
  has_import identify_with: { email: nil, first_name: [:last_name, :school_id] },
    associate: { school: :identifier, role: :name }
  
  before_validation :set_school

  validates_presence_of :email, :school, :first_name, :last_name
  validates_confirmation_of :password, if: :password_changed?
  validates_uniqueness_of :first_name, scope: [:last_name, :school_id],
    message: 'is the same as another user with the same last name in the same school, add a middle initial'
  validate :presence_of_role
  validate :periods_in_school
  validate :school_in_district
  
  def associate_students
    scope = case role_symbol
    when :principal, :secretary
      :school
    when :superintendent
      :district
    else
      :periods
    end
    
    self.class.has_many :students, through: scope
    # These must be defined after the "students" relation is defined.
    self.class.has_many :test_scores, through: :students
    self.class.has_many :test_models, through: :test_scores
  end
  
  def as_json options = {}
    super options.reverse_merge(only: [:id, :identifier], methods: [:name])
  end
  
  # Specify which column to use to check whether a collection has changed.
  # Necessary because Authlogic updates updated_at at every request.
  def self.cache_key_timestamp_column
    :user_updated_at
  end
  
  def self.find_by_name name
    first, last = extract_name_parts(name)
    where(first_name: first, last_name: last).first
  end
  
  def self.find_by_name! name
    find_by_name(name) || raise(::ActiveRecord::RecordNotFound, "Couldn't find User with name = #{name}")
  end
  
  def self.find_or_initialize_by_name name
    find_by_name(name) || new(name: name)
  end
  
  def name reversed = true
    reversed ? "#{last_name}, #{first_name}" : "#{first_name} #{last_name}"
  end
  
  def name= value
    first_name, last_name = self.extract_name_parts(name)
  end

  # Returns an array of the symbol of the role of the user.
  def role_symbols
  	[role_symbol]
  end
  
  # Return underscored symbol form of role name or nil.
  def role_symbol
    role ? role.name.underscore.to_sym : :default
  end
  
  # Override to read from the correct timestamp column
  def cache_key
    "users/#{id}-#{user_updated_at.to_s(:number)}"
  end
  
  private
  
  def update_appropriate_timestamps
    if (changed - AUTHLOGIC_MAGIC_COLUMNS).any?
      self.user_updated_at = self.updated_at
    end
  end
  
  # Return the first and last name from the given string.
  def self.extract_name_parts name
    if name =~ /,/
      last, *first = name.split(',')
    else
      *first, last = name.split(' ')
    end
    [first.join(' '), last].map(&:strip)
  end
  
  # For principals that cannot edit school_id, add school for them.
  def set_school
    if !school_id && Authorization.current_user.respond_to?(:school_id)
      school_id = Authorization.current_user.school_id
    end
  end
  
  # If no role was set, add teacher.
  def presence_of_role
    role ||= Role.find_by_name('Teacher')
  end
  
  # If the periods are not in the specified school, then add an error.
  def periods_in_school
    if periods.map(&:school_id).any?{|id| id != school_id }
      Rails.logger.info "PERIODS NOT IN SCHOOL (#{inspect}) [#{periods.map(&:school_id).inspect}] != #{school_id}"
      errors.add(:periods, 'must be in the school specified')
    end
  end
  
  # If the given school is not in the current user's scope of districts, then
  # add an error.
  def school_in_district
    if district && !permitted_to?(:show, object: district)
      errors.add(:school, 'must be in your district')
    end
  end

end
