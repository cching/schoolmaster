class ChangeBusColorColumns < ActiveRecord::Migration
  def up
    remove_column :bus_routes, :color
    add_column :bus_routes, :color_name, :string
    add_column :bus_routes, :color_value, :string, default: '#000000'
  end

  def down
    add_column :bus_routes, :color, :string
    remove_column :bus_routes, :color_name
    remove_column :bus_routes, :color_value
  end
end
