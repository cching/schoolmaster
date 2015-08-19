module PdfsHelper
  
  PARENTS[:pdfs] = [Template]
  
  SORTS[:pdfs] = {}
  
  FIELDS[:pdfs] = {
    index: [:name, :template],
    show: { fields: [:name, :file], relations: [:template, :types] },
    form: { fields: [:name, [:file, hint: 'must be a PDF']], relations: [:template]}
  }
  
end
