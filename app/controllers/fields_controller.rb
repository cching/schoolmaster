class FieldsController < ApplicationController
  
  def find_collection
    super.order('fields.name')
  end

end
