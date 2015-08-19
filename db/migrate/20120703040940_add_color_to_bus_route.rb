class AddColorToBusRoute < ActiveRecord::Migration
  def change
    add_column :bus_routes, :color, :string
  end
end
