class RemoveDistrictIdFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :district_id
  end

  def down
    add_column :users, :district_id, :integer
  end
end
