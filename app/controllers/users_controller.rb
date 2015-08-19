class UsersController < ApplicationController

  before_filter :set_params_id, only: [:show, :edit, :update, :destroy]
  
  def find_collection
    default = super.includes(:role, school: [:district]).order('users.last_name')
    if term = option_filter_value('term')
      if term == 'With No Period'
        default.with_no_period
      else
        default.joins(:periods).where(periods: { term: term })
      end
    else
      default
    end
  end
    
  # When there is no id passed in, check presence of current user. If
  # there is a current user, set params[:id] to the appropriate id for the
  # current user, otherwise redirect to login page.
  def set_params_id
    unless params[:id]
      if current_user
        params[:id] = current_user.id
      else
        require_user
      end
    end
  end
end
