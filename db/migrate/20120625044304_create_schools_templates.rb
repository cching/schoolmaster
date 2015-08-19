class CreateSchoolsTemplates < ActiveRecord::Migration
  def up
    create_table :schools_templates, id: false do |t|
      t.references :school
      t.references :template
    end
  end

  def down
    drop_table :schools_templates
  end
end
