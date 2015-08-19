class Period < ActiveRecord::Base

  using_access_control
  
  searches :name, :term
  
  attr_accessible :name, :student_ids, :user_ids, :term, :student, :user,
    as: [:developer, :superintendent, :principal, :secretary]
  attr_accessible :school_id, as: [:developer, :superintendent]
  attr_accessible :identifier, as: [:developer]

  belongs_to :school
  has_one :district, through: :school
  has_and_belongs_to_many :students
  has_many :test_scores, through: :students
  has_and_belongs_to_many :users
  
  has_import identify_with: { identifier: :school_id, name: :school_id },
    associate: { school: :identifier },
    prompts: proc { [[:school_id, collection: School.with_permissions_to(:show).order('name')]] }
  
  after_initialize :set_term, on: :create
  after_initialize :set_school
    
  before_validation :set_school
  
  validates_presence_of :name, :school
  validates_with Term
  validates_uniqueness_of :name, scope: :school_id
  validates_uniqueness_of :identifier, scope: :school_id, allow_blank: true
  
  validate :students_in_school
  validate :users_in_school
  validate :school_in_district
  
  def as_json options = {}
    super(options.reverse_merge(only: [:id])).reverse_merge(name: to_label)
  end
  
  # Used by formtastic.
  def to_label
    "#{term} #{name}"
  end
  
  # Returns a generic name for a user's period.
  def self.default_name_for user
    user.name
  end
  
  # What this model is called on the client end.
  def self.display_name
    'Class'
  end
  
  # Used by import
  def student= identifier
    added = Student.where(school_id: school_id, identifier: identifier).first
    raise "Could not find Student in #{school.name} where identifier = '#{identifier}'" unless added
    self.student_ids = ((student_ids || []) << added.id).uniq
  end
  
  # Used by import
  def user= name
    added = User.where(school_id: school_id).find_by_name(name)
    raise "Could not find User in #{school.name} where name = '#{name}'" unless added
    self.user_ids = ((user_ids || []) << added.id).uniq
  end
  
  private
  
  # If no term exists, set it to the current term.
  def set_term
    write_attribute(:term, Term.current) unless term.present?
  end
  
  # For principals that cannot edit school_id, add school for them.
  def set_school
    if !school_id && Authorization.current_user.respond_to?(:school_id)
      write_attribute(:school_id, Authorization.current_user.school_id)
    end
  end
  
  # If the students are not all in the same school as the period, then add an
  # error.
  def students_in_school
    if students.map(&:school_id).uniq.any?{|id| id != school_id }
      errors.add(:students, 'must be in the same school as the period')
    end
  end
  
  # If ther users are not all in the same school as the period, then add an
  # error.
  def users_in_school
    if users.map(&:school_id).uniq.any?{|id| id != school_id }
      errors.add(:users, 'must be in the same school as the period')
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
