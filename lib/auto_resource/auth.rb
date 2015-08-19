module Auth
  
  # When included, add the methods as helper methods.
  # Add filter resource access for declarative authorization.
  # Add before filter to call set_authorization.
  def self.included base
    base.helper_method :current_user, :current_user_session, :current_role
    base.before_filter :set_authorization
    base.filter_resource_access additional_collection:
      [:import, :export, :view_request, :clear, :toggle, :select, :form,
        :waiting, :upload, :help, :inline]
  end
  
  private
  
  # Used by declarative authorization to check permissions for new objects.
  def new_controller_object_from_params context, parent
    new_resource
  end
  
  # Executes the given block without access control. In other words, turns off
  # 'using_access_control' in the models.
  def without_access_control
    previous_state = Authorization.ignore_access_control
    Authorization.ignore_access_control(true)
    result = yield
  ensure
    Authorization.ignore_access_control(previous_state)
    result
  end

  # Connect declarative_authorization to authlogic.
  def set_authorization
    Authorization.current_user = current_user
  end

  # Returns the current user's session.
  def current_user_session
  	return @current_user_session if defined? @current_user_session
  	@current_user_session = without_access_control { UserSession.find }
  end

  # Returns the current user.
  def current_user
  	return @current_user if defined? @current_user
  	@current_user = current_user_session && current_user_session.record
  end
  
  # Returns the current user's role.
  def current_role
  	return @current_role if defined? @current_role
  	@current_role = current_user && current_user.role_symbol
  end
  
end