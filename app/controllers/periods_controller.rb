class PeriodsController < ApplicationController
  
  def find_collection
    default = super.includes(:school).order('periods.name')
    if term = option_filter_value('term')
      default.where(term: term)
    else
      default
    end
  end

end
