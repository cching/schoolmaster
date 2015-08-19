class PdfsController < ApplicationController
  
  def find_collection
    super.order('pdfs.name')
  end

end
