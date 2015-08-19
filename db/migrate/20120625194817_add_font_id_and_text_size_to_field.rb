class AddFontIdAndTextSizeToField < ActiveRecord::Migration
  def change
    add_column :fields, :font_id, :integer
    add_column :fields, :text_size, :decimal
  end
end
