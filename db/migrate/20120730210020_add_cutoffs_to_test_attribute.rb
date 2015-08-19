class AddCutoffsToTestAttribute < ActiveRecord::Migration
  def change
    add_column :test_attributes, :maximum_value, :decimal
    add_column :test_attributes, :advanced_proficient_boundary, :decimal
    add_column :test_attributes, :proficient_basic_boundary, :decimal
    add_column :test_attributes, :basic_below_basic_boundary, :decimal
    add_column :test_attributes, :below_basic_far_below_basic_boundary, :decimal
    add_column :test_attributes, :minimum_value, :decimal
  end
end
