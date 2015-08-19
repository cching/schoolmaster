class RemoveTestTables < ActiveRecord::Migration
  def up
    drop_table :test_scores
    drop_table :test_values
    drop_table :test_models
    drop_table :test_groups
    drop_table :test_attributes
  end

  def down
  end
end
