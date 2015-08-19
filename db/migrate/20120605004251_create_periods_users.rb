class CreatePeriodsUsers < ActiveRecord::Migration
  def up
  	create_table :periods_users, id: false do |t|
  		t.references :period
  		t.references :user
  	end
  end

  def down
  	drop_table :periods_users
  end
end
