class CreateBusStops < ActiveRecord::Migration
  def change
    create_table :bus_stops do |t|
      t.string :name
      t.integer :district_id

      t.timestamps
    end
  end
end
