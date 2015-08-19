class AddIdentifierToDistrict < ActiveRecord::Migration
  def change
    add_column :districts, :identifier, :string
  end
end
