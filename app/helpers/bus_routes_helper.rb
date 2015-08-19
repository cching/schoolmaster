module BusRoutesHelper

  PARENTS[:bus_routes] = [District]
  
  SORTS[:bus_routes] = {}
  
  FIELDS[:bus_routes] = {
    index: [:name, :color_name, :district],
    show: { fields: [:name, :color_name, :color_value], relations: [:district] },
    form: { fields: [:name, :color_name, :color_value], relations: [:district] }
  }

end
