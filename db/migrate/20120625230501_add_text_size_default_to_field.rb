class AddTextSizeDefaultToField < ActiveRecord::Migration
  def change
    change_column_default :fields, :text_size, 12
  end
end
