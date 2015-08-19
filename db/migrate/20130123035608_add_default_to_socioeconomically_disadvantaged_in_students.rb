class AddDefaultToSocioeconomicallyDisadvantagedInStudents < ActiveRecord::Migration
  def change
    change_column :students, :socioeconomically_disadvantaged, :boolean, default: false
  end
end
