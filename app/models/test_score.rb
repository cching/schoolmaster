class TestScore < ActiveRecord::Base
  
  CST_LEVELS = %w(adv prof basic bbasic fbb)
  
  CELDT_LEVELS = %w(adv ea int ei beg)
  
  using_access_control
  
  attr_accessible :data, :student_id, :term, :test_name,
    as: [:developer, :superintendent, :principal, :teacher]
  
  belongs_to :student
  has_many :users, through: :student
  
  serialize :data, ActiveRecord::Coders::Hstore
  
  validates_presence_of :student, :term, :test_name
  validates_uniqueness_of :test_name, scope: [:student_id, :term]
  validates_with Term
  
  searches student: [:first_name, :last_name, :identifier]
  
  has_import identify_with: { test_name: [:student_id, :term] },
    prompts: proc { [[:term, collection: Term.options_for_select, include_blank: false],
      [:school, collection: School.with_permissions_to(:show).order('name').map do |school|
        [school.to_label, school.identifier]
      end ]] },
    processor: TestScoreProcessor
  
  def test_name= value
    super(normalize_value(value))
  end
  
  def data= old_hash
    new_hash = {}
    old_hash.each do |key, value|
      new_hash[normalize_value(key)] = normalize_value(value)
    end
    super(new_hash)
  end
  
  def name
    test_name.titleize
  end
  
  private
  
  def normalize_value value
    value.try(:downcase).try(:strip)
  end
  
end
