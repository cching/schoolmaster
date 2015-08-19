class AddUserUpdatedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_updated_at, :timestamp
  end
end
