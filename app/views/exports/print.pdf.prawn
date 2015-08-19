begin
  # Pre-fetch all fonts, pdfs, and images.
  @export.fetch_files

  # Register fonts.
  @export.template.fonts.each do |font|
    pdf.font_families.update(font.name => {
      normal: font.file.url
    })
  end

  # Cache pdf.
  @pdf = Thread.current[:export_files][@export.pdf.file.url]

  @export.students.each do |student|

    pdf.start_new_page template: @pdf, margin: 0

    @export.template.fields.each do |field|
  
      # Handle image inserts.
      if Export.image_columns.include? field.column
        if url = student.send(field.column).try(:url)
          pdf.image Thread.current[:export_files][url],
            at: [field.x, field.y],
            width: field.width,
            height: field.height
        end
    
      # Handle colors.
      elsif Export.color_columns.include? field.column
        pdf.fill_color student.send(field.column)
        pdf.fill_rectangle [field.x, field.y], field.width, field.height
    
      # Handle text inserts.
      else
      
        text = if field.column == 'prompt'
          @export.prompt_values[field.name] || ""
        elsif field.column == 'type'
          @export.type.name
        else
          student.send(field.column)
        end
    
        pdf.font field.font.name
        pdf.fill_color field.color
        pdf.text_box text, at: [field.x, field.y], width: field.width,
          height: field.height, align: field.align.to_sym, size: field.text_size,
          overflow: :shrink_to_fit, character_spacing: field.spacing
      end
  
    end

  end

rescue => error
  pdf.start_new_page
  pdf.text error.message
  
ensure
  @export.dump_files
end