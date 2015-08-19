# Methods for automatically finding resource parents.
module Parents
  
  # When included, add the methods as helper methods.
  def self.included base
    base.helper_method :parent_path, :resource_with_parents
  end
  
  private
  
  # Add associations to a new record.
  def params_with_parents model, attributes = {}
    if parents = PARENTS[type_of(model)]
      parents.each do |parent|
        if id = params[id_attr(parent)]
          if has_valid_association(model, type_of(parent, false))
            attributes[id_attr(parent)] = id
          elsif has_valid_association(model, type_of(parent))
            attributes[ids_attr(parent)] = [id]
          end
        end
      end
    end
    attributes.with_indifferent_access
  end
  
  # Finds the correct path for the given index or show.
  def corrected_path
    unless controller_model
      request.path
    else
      if action_name == 'index'
        parent_path(controller_model)
      elsif action_name == 'show'
        parent_path(controller_model)
      elsif action_name == 'new'
        parent_path(new_resource)
      elsif action_name == 'export'
        context = params[:id] ? controller_model.find(params[:id]) : controller_model
        parent_path(context, action: 'export')
      else
        request.path
      end
    end
  end
  
  # Add parents to record and call polymorphic_path for those records.
  def parent_path record, options = {}
    options.reverse_merge!(action: :new) if new_record?(Array(record).first)
    parents = resource_with_parents(record)
    polymorphic_path(parents, options)
  end
  
  # Prepend parents of the given record to the array or record given and
  # return the array. Parents are determined by params and PARENTS.
  def resource_with_parents record
    if parents = PARENTS[type_of(record)]
      array = Array(record)
      first = array.first
      parents.each do |model|
        if id = params[id_key(model)]
          if first.is_a?(Symbol) || first.is_a?(Class)
            array.unshift model.find(id)
          else
            if association = first.class.reflect_on_association(type_of(model))
              if first.send(ids_attr(model)).include?(id.to_i) || association.options.has_key?(:through)
                array.unshift model.find(id)
              end
            elsif association = first.class.reflect_on_association(type_of(model, false))
              if direct = first.send(model.name.underscore)
                array.unshift direct
              elsif association.options.has_key?(:through)
                array.unshift model.find(id)
              end
            end
          end

        end
      end
      array
    else
      record
    end
  end
  
  private
  
  # Whether the given record and field has an association that is valid to set
  # through attributes.
  def has_valid_association model, field
    (association = model.reflect_on_association(field)) &&
    association &&
    !association.options.has_key?(:through)
  end
  
  # Return whether the record is new.
  def new_record? record
    record.respond_to?(:new_record?) && record.new_record?
  end
  
  # Return the symbol representing the key for the model in params.
  def id_key model
    model == controller_model ? :id : :"#{model.name.underscore}_id"
  end
  
  # Return the underscored, pluralized symbol representing the class of the
  # record.
  def type_of record, pluralize = true
    return record if record.is_a? Symbol
    record = record.class unless record.is_a?(Class)
    record = record.model_name
    record = record.pluralize if pluralize
    record.underscore.to_sym
  end
  
  # Returns the id attribute for the given model and optionally an appended
  # equals sign.
  def id_attr model
    :"#{model.name.underscore}_id"
  end
  
  # Pluralizes id_attr.
  def ids_attr model
    :"#{id_attr(model)}s"
  end
end