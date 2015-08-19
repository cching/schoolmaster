class RenameDisplayTeacherToHideTeacherInSchools < ActiveRecord::Migration
  def up
    remove_column :schools, :display_teacher
    add_column :schools, :hide_teacher, :boolean
  end

  def down
  end
end
