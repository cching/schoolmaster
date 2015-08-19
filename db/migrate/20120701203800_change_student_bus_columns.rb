class ChangeStudentBusColumns < ActiveRecord::Migration
  def up
    remove_column :students, :bus_pass_number
    remove_column :students, :am_bus_stop
    remove_column :students, :pm_bus_stop
    add_column :students, :bus_stop_id, :integer
    add_column :students, :bus_route_id, :integer
    add_column :students, :bus_rfid, :string
  end

  def down
  end
end
