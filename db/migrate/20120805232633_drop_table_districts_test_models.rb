class DropTableDistrictsTestModels < ActiveRecord::Migration
  def up
    drop_table :districts_test_models
  end

  def down
  end
end
