class CreateTestScores < ActiveRecord::Migration
  def change
    create_table :test_scores do |t|
      t.integer :student_id
      t.string :test_name
      t.string :term
      t.hstore :data

      t.timestamps
    end
  end
end
