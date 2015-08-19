class TypesController < ApplicationController
  
  def find_collection
    super.order('types.name')
  end

end
