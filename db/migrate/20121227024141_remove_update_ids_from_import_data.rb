class RemoveUpdateIdsFromImportData < ActiveRecord::Migration
  def up
    remove_column :import_data, :update_ids
  end

  def down
  end
end
