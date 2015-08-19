class DropTableRolesUsers < ActiveRecord::Migration
  def up
    drop_table :roles_users
  end

  def down
    create_table id: false do |t|
      t.references :role
      t.references :user
    end
  end
end
