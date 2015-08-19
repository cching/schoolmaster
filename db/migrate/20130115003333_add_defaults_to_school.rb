class AddDefaultsToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :default_note_header, :string
    add_column :schools, :default_note_content, :string
  end
end
