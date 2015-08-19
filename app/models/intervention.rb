class Intervention < ActiveRecord::Base
  
  using_access_control
  
  attr_accessible :name, :notes, :start, :stop, :completed, :student_id, as: [:developer,
    :superintendent, :principal, :teacher]
  
  belongs_to :student
  
  validates_presence_of :student
  
  def content_blank?
    name.blank? && start.blank? && stop.blank? && notes.blank?
  end
  
end
