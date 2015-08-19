class UserSessionsController < ApplicationController

  def new
  end

  def create
  	if without_access_control { @user_session.save }
  	  
  	  # Refresh current user variables.
  	  @current_user_session = @user_session
  	  @current_user = @user_session.record
  	  @current_role = @current_user.role_symbol
  	  
  	  # Render the navigation menu so it can be inserted into the page.
  	  render json: {
  	    page: render_to_string('application/_navigation', layout: false),
  	    export_list_styles: export_list_styles
  	  }
  	else
  		render json: {
  		  page: render_to_string('new')
  		}
  	end
  end

  def destroy
    current_user_session.destroy
  	
  	# Nothing needs to be rendered here.
  	render nothing: true
  end
  
  protected
  
  # Override to skip assign_attributes.
  def new_resource
    if params[:user_session] && params[:user_session][:login_as_guest] == 'true'
      Login.create(email: params[:user_session][:email])
      params[:user_session][:email] = Setting.value_of('Guest Account Email')
      params[:user_session][:password] = Setting.value_of('Guest Account Password')
    end
    @user_session = UserSession.new(params[:user_session])
  end
  
end
