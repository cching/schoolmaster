class SchoolsController < ApplicationController
  
  def find_collection
    super.includes(:district).order('schools.name')
  end
  
end
