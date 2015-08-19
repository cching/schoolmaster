module SchoolsHelper
  
  PARENTS[:schools] = [Type, Pdf, Template, District]
  
  SORTS[:schools] = {
    district: 'districts.name'
  }
  
  FIELDS[:schools] = {
    index: [:identifier, :name, :district],
    show: { fields: [:identifier, :name],
      relations: [:district, :users, :periods, :students, :test_scores] },
    form: { fields: [:identifier, :name, :mascot_image,
      :default_note_header, :default_note_content,
      :hide_teacher, :hide_socioeconomic_status],
      relations: [:district] }
  }
  
end
