class AddColumnToStudents < ActiveRecord::Migration
  def up
  	add_column :students, :data1, :string
  	add_column :students, :data2, :string
  end
end
