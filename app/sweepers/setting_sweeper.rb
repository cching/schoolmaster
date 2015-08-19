class SettingSweeper < ActionController::Caching::Sweeper
  observe Setting
  
  def after_update setting
    if setting.key == 'Login Page Text'
      expire_fragment('Login Page Text')
    end
  end
  
end