class UserSession < Authlogic::Session::Base
  
  attr_accessor :login_as_guest
  
  logout_on_timeout true
  
  after_save :log_login
  
  def initialize *args
    @login_as_guest = args.first.try(:[], :login_as_guest) == 'true' ? true : false
    super
  end

  # Included for formtastic patch where fields are disabled if they are not
  # accessible by the current user.
  def self.accessible_attributes role = nil
    [:email, :password, :login_as_guest]
  end
  
  private
  
  def log_login
    unless login_as_guest
      Login.create(email: email)
    end
  end
  
end
