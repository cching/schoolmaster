class CreateTablePeriodsStudents < ActiveRecord::Migration
  def up
  	create_table :periods_students, id: false do |t|
  		t.references :period
  		t.references :student
	end
  end

  def down
  	drop_table :periods_students
  end
end
