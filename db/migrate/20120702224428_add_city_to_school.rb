class AddCityToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :city, :string
  end
end
