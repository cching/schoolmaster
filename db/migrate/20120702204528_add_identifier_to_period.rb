class AddIdentifierToPeriod < ActiveRecord::Migration
  def change
    add_column :periods, :identifier, :string
  end
end
