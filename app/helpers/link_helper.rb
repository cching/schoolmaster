module LinkHelper
	
	# Generates a link for the given action and model_or_record and returns it
	# only if the current user is allowed to visit that link.
	def link_for *args
	  options = args.extract_options!
	  action = args.length > 1 ? args.first.to_sym : :show
	  model_or_record = args.last
	  
	  classes = (options[:class] || '').split(' ')
	  classes << if model_or_record.respond_to?(:model_name)
	    model_or_record.model_name
	  else
	    model_or_record.class
    end.to_s.underscore
    classes << action
    options[:class] = classes.join(' ')
	  
		case action
	  when :index
	    return unless permitted_to? action, model_or_record
      link_to model_or_record.model_name.titleize.pluralize,
        parent_path(model_or_record), options
	    
    when :show
      link_to_if permitted_to?(action, model_or_record),
        "View #{model_or_record.class}", parent_path(model_or_record), options
        
    when :edit
      return unless permitted_to? action, model_or_record
        link_to 'Edit', js_link, options
      
    when :update
      link_to 'Save', js_link, options
      
    when :new
      return unless permitted_to? action, model_or_record
      link_to 'New', parent_path(model_or_record, { action: :new }), options
      
    when :create
      link_to 'Create', js_link, options
      
    when :destroy
      return unless permitted_to? action, model_or_record
      if model_or_record.is_a?(TestScore)
        link_to 'Delete', "/test_scores/#{model_or_record.student_id}/#{model_or_record.id}", options
      else
        link_to 'Delete', parent_path(model_or_record), options
      end
      
    when :cancel
      link_to 'Cancel', js_link, options
    
    when :back
      link_to 'Back', js_link, options
    
    when :print
      link_to 'Print', js_link, options
    
    when :previous
      link_to 'Previous', js_link, options
    
    when :next
      link_to 'Next', js_link, options
      
    when :search
      if (model_or_record.is_a?(Class) ? model_or_record : model_or_record.class).respond_to?(:search)
        link_to 'Search', js_link, options
      end
      
    when :import
      if permitted_to?(action, model_or_record) && ImportData.for?(model_or_record)
        link_to 'Import', js_link, options
      end
    
    when :export
      if permitted_to?(action, model_or_record) && model_or_record.is_a?(Student)
        link_to 'Export', "#{parent_path(model_or_record)}/export", options
      end
      
    when :upload
      if model_or_record == ExportListItem
        if permitted_to?(action, model_or_record)
          link_to 'Upload', js_link, options
        end
      else
        link_to 'Upload', js_link, options
      end
    
    when :fullscreen
      link_to 'Fullscreen', js_link, options
    
    when :help
      link_to 'Help', js_link, options
    end
	end
  
end