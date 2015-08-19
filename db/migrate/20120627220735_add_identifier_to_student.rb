class AddIdentifierToStudent < ActiveRecord::Migration
  def change
    add_column :students, :identifier, :string
  end
end
