class BusStop < ActiveRecord::Base
  
  using_access_control
  
  searches :name
  
  attr_accessible :district_id, :name, as: [:developer]
  
  belongs_to :district
  
  validates_presence_of :name, :district
  validates_uniqueness_of :name, scope: :district_id
  
  has_import identify_with: { name: :district_id },
    associate: { district: :identifier }
end
