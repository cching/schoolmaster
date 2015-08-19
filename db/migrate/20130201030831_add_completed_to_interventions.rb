class AddCompletedToInterventions < ActiveRecord::Migration
  def change
    add_column :interventions, :completed, :boolean, default: false
  end
end
