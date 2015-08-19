class AddParentIdToTestAttributes < ActiveRecord::Migration
  def change
    add_column :test_attributes, :parent_id, :integer
  end
end
