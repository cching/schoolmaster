class AddIntervenedToStudents < ActiveRecord::Migration
  def change
    add_column :students, :intervened, :boolean
  end
end
