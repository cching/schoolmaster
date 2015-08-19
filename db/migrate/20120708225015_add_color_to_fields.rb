class AddColorToFields < ActiveRecord::Migration
  def change
    add_column :fields, :color, :string, default: '#000000'
  end
end
