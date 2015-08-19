class HelpController < ApplicationController
  
  filter_resource_access additional_collection: :page
  
  def index
  end

  def page
    render "help/#{params[:path]}"
  end
end
