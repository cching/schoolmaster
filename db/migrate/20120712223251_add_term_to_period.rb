class AddTermToPeriod < ActiveRecord::Migration
  def change
    add_column :periods, :term, :string
  end
end
