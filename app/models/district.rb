class District < ActiveRecord::Base

  using_access_control
  
  searches :name, :identifier

  attr_accessible :school_ids, :test_group_ids, :name, :identifier, :zpass, as: :developer

  has_many :schools, dependent: :destroy
  has_many :users, through: :schools, extend: WithTermExtension
  has_many :students, through: :schools, extend: WithTermExtension
  has_many :test_scores, through: :students
  has_many :bus_stops, dependent: :destroy
  has_many :bus_routes, dependent: :destroy
  
  has_import identify_with: { identifier: nil }
  
  validates_presence_of :name
  validates_uniqueness_of :identifier
end
