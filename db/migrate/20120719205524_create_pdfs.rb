class CreatePdfs < ActiveRecord::Migration
  def change
    create_table :pdfs do |t|
      t.string :name
      t.string :file_file_name
      t.integer :file_file_size
      t.string :file_content_type
      t.datetime :file_updated_at
      t.integer :template_id

      t.timestamps
    end
  end
end
