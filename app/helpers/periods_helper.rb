module PeriodsHelper
  
  PARENTS[:periods] = [Student, User, School, District]
  
  SORTS[:periods] = {
    school: 'school.name'
  }
  
  FIELDS[:periods] = {
    index: [:name, :school],
    show: { fields: [:name, :term], relations: [:school, :students, :users, :test_scores]},
    form: { fields: [:name, [:term, collection: Term.choices]],
      relations: [[:school, as: :search_select], [:students, as: :token, depends_on: :school],
      [:users, as: :token, depends_on: :school]] }
  }
  
end
