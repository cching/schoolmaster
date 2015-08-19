class AddSpacingToFields < ActiveRecord::Migration
  def change
    add_column :fields, :spacing, :decimal, default: 0
  end
end
