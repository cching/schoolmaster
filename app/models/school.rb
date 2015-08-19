class School < ActiveRecord::Base

  using_access_control
  
  searches :name, :identifier

  attr_accessible :hide_teacher, :hide_socioeconomic_status, as: :developer
  attr_accessible :name, :period_ids, :student_ids, as: [:developer,
    :superintendent]
  attr_accessible :district_id, :user_ids, :identifier, :mascot_image, :city,
    :type_ids, :default_note_header, :default_note_content, as: [:developer]

  belongs_to :district
  has_many :users, dependent: :destroy, extend: WithTermExtension
  has_many :periods, dependent: :destroy, extend: WithTermExtension
  has_many :students, dependent: :destroy, extend: WithTermExtension
  has_many :test_scores, through: :students
  has_and_belongs_to_many :types
  
  has_attached_file :mascot_image, path: '/school_mascots/:id/:basename_:style.:extension',
    styles: { thumbnail: '35x35^', original: ['', :png] }
  
  has_import identify_with: { identifier: nil }, associate: { district: :identifier }
  
  validates_presence_of :name, :district, :identifier
  validates_uniqueness_of :identifier
  
  def as_json options = {}
    super(options.reverse_merge(only: [:id, :district_id])).reverse_merge(name: to_label)
  end
  
  def to_label
    "#{identifier} #{name}"
  end
  
  def default_note_content
    if (value = super).present?
      value
    else
      Setting.value_of('Default Note Content')
    end
  end
  
  def default_note_header
    if (value = super).present?
      value
    else
      Setting.value_of('Default Note Header')
    end
  end

end
