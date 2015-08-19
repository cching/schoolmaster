class RemoveNotesFromStudent < ActiveRecord::Migration
  def up
    remove_column :students, :notes
  end

  def down
    add_column :students, :notes, :text
  end
end
