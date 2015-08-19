class TemplatesController < ApplicationController

  def find_collection
    super.order('templates.name')
  end

end
