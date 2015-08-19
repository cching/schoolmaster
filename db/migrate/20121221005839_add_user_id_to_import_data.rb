class AddUserIdToImportData < ActiveRecord::Migration
  def change
    add_column :import_data, :user_id, :integer
  end
end
