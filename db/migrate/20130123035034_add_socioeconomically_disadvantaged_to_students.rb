class AddSocioeconomicallyDisadvantagedToStudents < ActiveRecord::Migration
  def change
    add_column :students, :socioeconomically_disadvantaged, :boolean
  end
end
