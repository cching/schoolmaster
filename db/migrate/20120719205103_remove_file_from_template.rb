class RemoveFileFromTemplate < ActiveRecord::Migration
  def up
    remove_attachment :templates, :file
  end

  def down
  end
end
