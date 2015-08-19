class Type < ActiveRecord::Base
  
  using_access_control
  
  searches :name
  
  attr_accessible :name, :pdf_id, :school_ids, as: :developer

  has_and_belongs_to_many :schools
  belongs_to :pdf
  has_one :template, through: :pdf
  
  validates_presence_of :name, :pdf
  
end
