module FieldsHelper
  
  PARENTS[:fields] = [Template]
  
  FIELDS[:fields] = {
    index: [:name, :column, :template],
    show: { fields: [:name, :column, :x, :y, :width, :height, :font, :text_size, :color,
      :align, :spacing], relations: [:template] },
    form: { fields: [:name, [:column, collection: Student.template_column_options],
      [:x, hint: 'from the left'], [:y, hint: 'from the bottom'], :width,
      :height, :font, :text_size, [:color, hint: 'without the "#"'],
      [:align, collection: Field.align_options], :spacing], relations: [:template] }
  }
  
end
