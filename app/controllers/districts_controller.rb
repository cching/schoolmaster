class DistrictsController < ApplicationController
  
  def find_collection
    super.order('districts.name')
  end
  
  protected
  
  def new_district_from_params
    @district ||= District.new.tap do |district|
      district.assign_attributes params[:district], as: current_role
    end
  end
end
