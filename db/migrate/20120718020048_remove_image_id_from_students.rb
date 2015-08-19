class RemoveImageIdFromStudents < ActiveRecord::Migration
  def up
    remove_column :students, :image_id
  end

  def down
  end
end
