class BusRoutesController < ApplicationController
  
  def find_collection
    super.includes(:district).order('bus_routes.name')
  end
  
end
