module UsersHelper
  
  PARENTS[:users] = [Student, Period, School, District]
  
  SORTS[:users] = {
    name: 'users.last_name',
    school: 'schools.name',
    role: 'roles.name'
  }
  
  FIELDS[:users] = {
    index: [:name, :school, :role],
    show: { fields: [:email, :role],
      relations: [:district, :school, :periods, :students, :test_scores]},
    form: { fields: [:first_name, :last_name, :email, :password,
      :password_confirmation], relations: [[:school, as: :search_select],
      [:periods, as: :token, label: 'Classes', depends_on: :school], :role] }
  }

end
