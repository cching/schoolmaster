class Role < ActiveRecord::Base

  using_access_control

  attr_accessible :name

  has_many :users
  
  validates_presence_of :name
  
end
