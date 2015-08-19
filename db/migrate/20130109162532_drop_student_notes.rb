class DropStudentNotes < ActiveRecord::Migration
  def up
    drop_table :student_notes
  end

  def down
  end
end
