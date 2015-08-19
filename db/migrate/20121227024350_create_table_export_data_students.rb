class CreateTableExportDataStudents < ActiveRecord::Migration
  def up
    create_table 'export_data_students', id: false do |t|
      t.references :student
      t.references :export_data
    end
  end

  def down
    drop_table 'export_data_students'
  end
end
