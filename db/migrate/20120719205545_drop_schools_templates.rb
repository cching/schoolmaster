class DropSchoolsTemplates < ActiveRecord::Migration
  def up
    drop_table :schools_templates
  end

  def down
  end
end
