class AddNotesColumnsToStudents < ActiveRecord::Migration
  def change
    add_column :students, :note_1, :text
    add_column :students, :note_2, :text
    add_column :students, :note_3, :text
    add_column :students, :note_4, :text
  end
end
