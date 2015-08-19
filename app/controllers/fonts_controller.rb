class FontsController < ApplicationController
  
  def find_collection
    super.order('fonts.name')
  end
  
end
