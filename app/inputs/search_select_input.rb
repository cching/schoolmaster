class SearchSelectInput < TokenInput
  
  def raw_collection
    default = options[:include_blank] ? [] : reflection.klass.first
    Array.wrap(super || default)
  end
  
  # Add icon for clear button.
  def choice_html(choice)
    first = raw_collection.first
    district_id = first.is_a?(School) && first.district_id
    district_field = if district_id
      template.hidden_field_tag(nil, district_id, id: 'search_select_district_id')
    else
      ''
    end
    
    template.content_tag(:label,
      template.hidden_field_tag(input_name, choice_value(choice)) <<
      choice_label(choice) <<
      district_field,
      label_html_options.merge(:for => choice_input_dom_id(choice), :class => nil)
    )
  end
  
  def input_name
    "#{object_name}[#{association_primary_key || method}]"
  end
  
end