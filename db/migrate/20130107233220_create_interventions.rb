class CreateInterventions < ActiveRecord::Migration
  def change
    create_table :interventions do |t|
      t.integer :student_id
      t.string :name
      t.date :start
      t.date :stop
      t.text :notes

      t.timestamps
    end
  end
end
