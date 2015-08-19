module BusStopsHelper
  
  PARENTS[:bus_stops] = [District]
  
  SORTS[:bus_stops] = {}
  
  FIELDS[:bus_stops] = {
    index: [:name, :district],
    show: { fields: [:name], relations: [:district] },
    form: { fields: [:name], relations: [:district] }
  }
  
end
