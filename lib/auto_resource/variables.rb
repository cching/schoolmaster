# Creates setter and getter methods for common variables so they can be
# accessed namelessley, relying on the current controller's name.
module Variables
  
  # When included, add the methods as helper methods.
  def self.included base
    base.helper_method :controller_model, :resource, :collection, :option_filter_value
  end
  
  private
  
  # Return the model with the same name as the current controller.
  def controller_model
    @controller_model ||= begin
      controller_name.singularize.camelize.constantize
    rescue
      nil
    end
  end
  
  # Return the record associated with the current controller.
  def resource
    instance_variable_get(resource_name) || params[:id] && set_resource(controller_model.find(params[:id]))
  end
  
  # Set the record variable equal to value.
  def set_resource value
    instance_variable_set(resource_name, value)
  end
  
  # Return the collection of records associated with the current controller.
  def collection
    instance_variable_get(collection_name) || set_collection(find_collection)
  end
  
  # Set the collection variable equal to value.
  def set_collection value
    instance_variable_set(collection_name, value)
  end
  
  private
  
  # Return false if the parameter is not present or equal to 'All' or return
  # the parameter's value.
  def option_filter_value option
    option = "#{option}_filter"
    params[option].present? && params[option] != 'All' && params[option]
  end
  
  # Return the name for resource variable.
  def resource_name
    :"@#{controller_name.singularize}"
  end
  
  # Return the name for the collection variable
  def collection_name
    :"@#{controller_name}"
  end
  
end