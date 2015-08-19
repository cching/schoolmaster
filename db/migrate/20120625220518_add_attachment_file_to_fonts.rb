class AddAttachmentFileToFonts < ActiveRecord::Migration
  def self.up
    change_table :fonts do |t|
      t.has_attached_file :file
    end
  end

  def self.down
    drop_attached_file :fonts, :file
  end
end
