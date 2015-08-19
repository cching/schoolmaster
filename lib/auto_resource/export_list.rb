module ExportList
  
  def self.included base
    base.helper_method :export_list_styles, :student_select_class
  end
  
  def export_list_styles
    selectors = current_user.export_list_items.pluck(:student_id).map do |id|
      ".#{student_select_class(id)}"
    end.join(', ')
    if selectors.present?
      "#{selectors} { background-position: 10px -2118px !important; }"
    end
  end
  
  def student_select_class id
    "students-select-#{id}"
  end
  
  def export_list_count_and_styles
    {
      export_list_count: current_user.export_list_students.count,
      export_list_styles: export_list_styles
    }
  end
  
  def insert_student_ids_into_export_list_items student_ids
    timestamp = "'#{Time.now.utc.to_s(:db)}'"
    values = student_ids.map do |id|
      %((#{timestamp},#{timestamp},#{id},#{current_user.id}))
    end.join(',')
    Student.connection.execute(%(INSERT INTO export_list_items ("created_at", "updated_at", "student_id", "user_id") VALUES #{values}))
  end
  
end