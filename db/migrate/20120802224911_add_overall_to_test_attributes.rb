class AddOverallToTestAttributes < ActiveRecord::Migration
  def change
    add_column :test_attributes, :overall, :boolean, default: false
  end
end
