class BusStopsController < ApplicationController
  
  def find_collection
    super.includes(:district).order('bus_stops.name')
  end

end
