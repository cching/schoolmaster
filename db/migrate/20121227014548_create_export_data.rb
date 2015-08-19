class CreateExportData < ActiveRecord::Migration
  def change
    create_table :export_data do |t|
      t.text :student_ids
      t.string :kind
      t.integer :type_id
      t.text :prompt_values
      t.string :sort_by
      t.string :certificate_title
      t.string :distribution_date
      t.text :additional_information
      t.integer :user_id

      t.timestamps
    end
  end
end
