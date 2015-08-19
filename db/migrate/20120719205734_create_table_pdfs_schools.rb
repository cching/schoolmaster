class CreateTablePdfsSchools < ActiveRecord::Migration
  def up
    create_table :pdfs_schools, id: false do |t|
      t.references :pdf
      t.references :school
    end
  end

  def down
  end
end
