class AddTestGroupIdToTestModel < ActiveRecord::Migration
  def change
    add_column :test_models, :test_group_id, :integer
  end
end
