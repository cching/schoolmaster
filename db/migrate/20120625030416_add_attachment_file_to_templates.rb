class AddAttachmentFileToTemplates < ActiveRecord::Migration
  def self.up
    change_table :templates do |t|
      t.has_attached_file :file
    end
  end

  def self.down
    drop_attached_file :templates, :file
  end
end
