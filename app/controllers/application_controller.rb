class ApplicationController < ActionController::Base

  protect_from_forgery
  
  before_filter :to_shoobphoto
  before_filter :handle_non_xhr
  
  layout 'xhr'
  
  include Methods
  include Variables
  include Parents
  include Resources
  include Response
  include Auth
  include Errors
  include Caching
  include ExportList
  include TestScores

  private
  
  # If visiting schoolsupport.herokuapp.com, redirect to schoolsupport.shoobphoto.com
  def to_shoobphoto
    if request.host =~ /herokuapp/i
      redirect_to "#{request.protocol}#{request.host.sub(/herokuapp/, 'shoobphoto')}:#{request.port}#{request.fullpath}"
    end
  end
  
  # If the request is not xhr, render only the layout.
  def handle_non_xhr
    file_upload = params['X-Requested-With'] == 'IFrame'
    export = params[:view_request] && request.put? && !request.xhr?
    export ||= params[:export_data_id] || request.post?
    skip = params[:xhr] == 'true'
    unless export || request.xhr? || file_upload || skip
      if request.path != root_path
        path = current_user ? corrected_path : root_path
        redirect_to root_url, flash: { initial_path: path }
      else
        render 'blank', layout: 'application'
      end
    end
    if skip
      headers['Content-Type'] = 'text/plain'
    end
  end
  
end
