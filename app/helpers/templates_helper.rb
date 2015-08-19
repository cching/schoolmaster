module TemplatesHelper

  FIELDS[:templates] = {
    index: [:name],
    show: { fields: [:name], relations: [:fields, :pdfs] },
    form: { fields: [:name], relations: [] }
  }
  
  SORTS[:templates] = {}
  
end
