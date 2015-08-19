class ChangeStartStopTypeOfInterventionsToString < ActiveRecord::Migration
  def up
    change_column :interventions, :start, :string
    change_column :interventions, :stop, :string
  end

  def down
  end
end
