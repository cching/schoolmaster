class AddDistrictIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :district_id, :integer
    add_column :users, :school_id, :integer
  end
end
