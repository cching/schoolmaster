Formtastic::FormBuilder.include_blank_for_select_by_default = false
Formtastic::FormBuilder.i18n_lookups_by_default = true

module Formtastic
  
  module Helpers::InputHelper
  
    # Return whether the current user is allowed to edit the given field.
    def allowed_to_edit method
      @allowed_to_edit ||= {}
      @allowed_to_edit[method] ||= begin
        return true unless @object.class.respond_to? :accessible_attributes
        field = association_primary_key_for_method(method) || method
        role = Authorization.current_user.role_symbols.first
        @object.class.accessible_attributes(role).include?(field)
      end
    end
  
    alias_method :input_super, :input
    # Return nothing if not allowed to edit.
    def input method, options = {}
      input_super(method, options) if allowed_to_edit(method)
    end
  
    alias_method :default_input_type_super, :default_input_type
    # Make the default collection input type for has_many and habtm associations
    # check boxes.
    def default_input_type method, options = {}
      if @object && association_macro_for_method(method) =~ /^has/
        :check_boxes
      else
        default_input_type_super(method, options)
      end
    end
  
  end

  module Inputs::Base
    
    # For collections, only show options that the current user can see.
    def collection_from_association
      records = super
      if records.respond_to?(:with_permissions_to)
        records = records.with_permissions_to(:show)
      end
      records
    end
  end
end