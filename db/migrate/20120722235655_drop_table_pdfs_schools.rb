class DropTablePdfsSchools < ActiveRecord::Migration
  def up
    drop_table :pdfs_schools
  end

  def down
  end
end
