class ChangeDefaultOfHideTeacherToFalseInSchools < ActiveRecord::Migration
  def up
    change_column :schools, :hide_teacher, :boolean, default: false
  end

  def down
  end
end
