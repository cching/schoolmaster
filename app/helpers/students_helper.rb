module StudentsHelper
  
  PARENTS[:students] = [Period, User, School, District]
  
  SORTS[:students] = {
    name: 'students.last_name',
    teacher: 'users.last_name'
  }
  
  FIELDS[:students] = {
    index: [:identifier, :name, :grade, :teacher],
    show: { fields: [:identifier, :grade, :hispanic, :english_learner, :socioeconomically_disadvantaged,
      :phone, :email, :parent_name, :teacher],
      relations: [:periods, :users, :school, :district]},
    form: { fields: [:identifier, :first_name, :last_name, :grade, :email, :phone, :parent_name,
      [:hispanic, as: :radio], [:english_learner, as: :radio], [:socioeconomically_disadvantaged, as: :radio],
      [:dropped, as: :radio], :image], relations: [[:school, as: :search_select],
      [:bus_stop, as: :search_select, depends_on: :district], [:bus_route,
        as: :search_select, depends_on: :district], [:periods, as: :token,
          label: 'Classes', depends_on: :school]] }
  }
  
  def sort_interventions interventions
    interventions.sort_by do |intervention|
      if %w(name start stop notes).map {|c| intervention.send(c) }.all?(&:blank?)
        Time.now
      else
        intervention.created_at
      end
    end
  end
  
end
