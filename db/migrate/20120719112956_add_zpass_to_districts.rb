class AddZpassToDistricts < ActiveRecord::Migration
  def change
    add_column :districts, :zpass, :boolean, default: false
  end
end
