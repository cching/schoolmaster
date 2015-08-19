class CreateTableDistrictsTestGroups < ActiveRecord::Migration
  def up
    create_table :districts_test_groups, id: false do |t|
      t.references :district
      t.references :test_group
    end
  end

  def down
  end
end
