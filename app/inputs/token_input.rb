class TokenInput < Formtastic::Inputs::CheckBoxesInput
  
  def raw_collection
    @object.send(method)
  end
  
  # Add search field.
  def choices_group_wrapping(&block)
    template.content_tag(:ol,
      template.capture(&block) <<
      template.content_tag(:li,
        template.text_field_tag(nil),
        class: 'search_field'
      ),
      choices_group_wrapping_html_options
    ) << template.content_tag(:ol, '', class: 'results')
  end

  # Add icon for clear button.
  def choice_html(choice)
    template.content_tag(:label,
      template.hidden_field_tag(input_name, choice_value(choice)) <<
      choice_label(choice) <<
      template.content_tag(:i),
      label_html_options.merge(:for => choice_input_dom_id(choice), :class => nil)
    )
  end
  
  def wrapper_html_options
    hash = super
    hash[:data] = { depends_on: options[:depends_on] } if options[:depends_on]
    hash
  end
  
end