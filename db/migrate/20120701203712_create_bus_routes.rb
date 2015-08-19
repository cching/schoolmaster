class CreateBusRoutes < ActiveRecord::Migration
  def change
    create_table :bus_routes do |t|
      t.string :name
      t.integer :district_id

      t.timestamps
    end
  end
end
