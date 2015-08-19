class AddDroppedToStudents < ActiveRecord::Migration
  def change
    add_column :students, :dropped, :boolean
  end
end
