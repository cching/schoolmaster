class LoginsController < ApplicationController
  
  def find_collection
    super.order('created_at DESC')
  end
  
end