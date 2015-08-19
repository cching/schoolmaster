class CreateStudentNotes < ActiveRecord::Migration
  def change
    create_table :student_notes do |t|
      t.integer :student_id
      t.integer :user_id
      t.text :notes

      t.timestamps
    end
  end
end
