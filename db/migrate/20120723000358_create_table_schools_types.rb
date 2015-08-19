class CreateTableSchoolsTypes < ActiveRecord::Migration
  def up
    create_table :schools_types, id: false do |t|
      t.references :school
      t.references :type
    end
  end

  def down
    drop_table :schools_types
  end
end
