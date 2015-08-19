class Font < ActiveRecord::Base
  
  using_access_control
  
  searches :name
  
  attr_accessible :name, :file, as: [:developer]
  
  has_many :fields
  
  has_attached_file :file, path: '/fonts/:id/:filename'
  
  validates_presence_of :name
  validates_attachment :file, presence: true
  
  before_destroy :ensure_no_fields
  
  private
  
  def ensure_no_fields
    if fields.any?
      errors.add :base, 'Cannot be deleted. There are fields that use this font.'
    end
    false
  end
end
