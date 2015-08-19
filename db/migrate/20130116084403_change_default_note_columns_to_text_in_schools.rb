class ChangeDefaultNoteColumnsToTextInSchools < ActiveRecord::Migration
  def up
    change_column :schools, :default_note_content, :text
  end

  def down
  end
end
