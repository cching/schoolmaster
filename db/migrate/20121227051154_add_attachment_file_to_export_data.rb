class AddAttachmentFileToExportData < ActiveRecord::Migration
  def self.up
    change_table :export_data do |t|
      t.has_attached_file :file
    end
  end

  def self.down
    drop_attached_file :export_data, :file
  end
end
