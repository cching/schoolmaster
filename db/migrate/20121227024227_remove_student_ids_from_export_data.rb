class RemoveStudentIdsFromExportData < ActiveRecord::Migration
  def up
    remove_column :export_data, :student_ids
  end

  def down
  end
end
