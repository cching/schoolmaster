class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :grade
      t.string :am_bus_stop
      t.string :pm_bus_stop
      t.string :bus_pass_number

      t.timestamps
    end
  end
end
