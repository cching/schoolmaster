class AddDisplayTeacherToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :display_teacher, :boolean
  end
end
