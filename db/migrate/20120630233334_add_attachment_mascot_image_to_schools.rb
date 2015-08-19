class AddAttachmentMascotImageToSchools < ActiveRecord::Migration
  def self.up
    change_table :schools do |t|
      t.has_attached_file :mascot_image
    end
  end

  def self.down
    drop_attached_file :schools, :mascot_image
  end
end
