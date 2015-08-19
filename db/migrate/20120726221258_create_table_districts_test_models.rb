class CreateTableDistrictsTestModels < ActiveRecord::Migration
  def up
    create_table :districts_test_models, id: false do |t|
      t.references :district
      t.references :test_model
    end
  end

  def down
    drop_table :districts_test_models
  end
end
