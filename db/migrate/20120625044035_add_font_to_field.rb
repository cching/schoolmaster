class AddFontToField < ActiveRecord::Migration
  def change
    add_column :fields, :font, :string
  end
end
