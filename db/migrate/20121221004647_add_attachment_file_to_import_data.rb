class AddAttachmentFileToImportData < ActiveRecord::Migration
  def self.up
    change_table :import_data do |t|
      t.has_attached_file :file
    end
  end

  def self.down
    drop_attached_file :import_data, :file
  end
end
