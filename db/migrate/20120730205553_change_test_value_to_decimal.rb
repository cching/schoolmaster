class ChangeTestValueToDecimal < ActiveRecord::Migration
  def up
    remove_column :test_values, :value
    add_column :test_values, :value, :decimal, default: 0
  end

  def down
  end
end
