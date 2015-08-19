class AddTestModelIdToTestAttributes < ActiveRecord::Migration
  def change
    add_column :test_attributes, :test_model_id, :integer
  end
end
