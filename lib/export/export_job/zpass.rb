class ExportJob
  
  class Zpass
    
    def initialize export_data, path
      @export_data, @path = export_data, path
    end
    
    def generate 
      require 'csv'
      CSV.open(@path, 'w') do |csv|
        csv << %w(bus_rfid st_lname st_fname st_stu_id st_grade note)
        @export_data.students.each do |student|
          csv << (%w(bus_rfid last_name first_name identifier grade).map do |column|
            student.send(column)
          end << nil)
        end
      end
    end
    
  end
  
end