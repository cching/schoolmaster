class AddHispanicAndEnglishLearnerToStudent < ActiveRecord::Migration
  def change
    add_column :students, :hispanic, :boolean, default: false
    add_column :students, :english_learner, :boolean, default: false
  end
end
