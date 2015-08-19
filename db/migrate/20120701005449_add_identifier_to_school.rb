class AddIdentifierToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :identifier, :string
  end
end
