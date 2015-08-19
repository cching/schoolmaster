class AddDisplaySocioeconomicStatusToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :display_socioeconomic_status, :boolean, default: true
  end
end
