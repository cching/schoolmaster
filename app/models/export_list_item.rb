class ExportListItem < ActiveRecord::Base
  
  using_access_control
  
  attr_accessible :student_id, :user_id
  
  belongs_to :student
  belongs_to :user
  
end
