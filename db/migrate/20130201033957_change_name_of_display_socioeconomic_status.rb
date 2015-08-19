class ChangeNameOfDisplaySocioeconomicStatus < ActiveRecord::Migration
  def up
    remove_column :schools, :display_socioeconomic_status
    add_column :schools, :hide_socioeconomic_status, :boolean, default: false
  end

  def down
  end
end
