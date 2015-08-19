class TestScoreProcessor
  
  def self.call hash, import_data
    model = import_data.model
    
    # Associate the student because has_import does not have an option to
    # associate with a scope (school) because student identifiers are only
    # guaranteed to be unique in a school. Also necessary because school
    # would be added to the data column in the code below if not removed here. 
    identifier = hash.delete(:school)
    school = School.where(identifier: identifier).first
    raise "Could not find the school where identifier = '#{identifier}'" unless school
    identifier = hash.delete(:student)
    student = school.students.where(identifier: identifier).first
    raise "Could not find the student in #{school.name} where identifier = '#{identifier}'" unless student
    hash[:student_id] = student.id
    
    hash[:test_name].try(:downcase!)
    
    # Put all columns present in the hash but not present in the model in
    # the serialized data column. Also ensure that all keys are lowercase
    # to prevent duplicate keys like 'Ela' and 'ela'.
    hash[:data] = {}
    hash.each do |key, value|
      unless model.column_names.include?(key.to_s)
        hash.delete(key)
        hash[:data][key.downcase] = value.try(:downcase)
      end
    end
  end
  
end