class CreateImportData < ActiveRecord::Migration
  def change
    create_table :import_data do |t|
      t.string :model
      t.text :defaults
      t.text :prompt_values
      t.text :update_ids

      t.timestamps
    end
  end
end
