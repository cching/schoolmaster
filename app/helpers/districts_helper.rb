module DistrictsHelper
  
  SORTS[:districts] = {}
  
  FIELDS[:districts] = {
    index: [:identifier, :name],
    show: { fields: [:identifier, :name],
      relations: [:schools, :users, :students, :bus_routes, :bus_stops]},
    form: { fields: [:identifier, :name, [:zpass, as: :radio]], relations: [] }
  }
  
end
