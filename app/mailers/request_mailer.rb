class RequestMailer < ActionMailer::Base
  
  def request_form export
    @export = export
    @user = Authorization.current_user
    attachments["#{@export.certificate_title}.csv"] = generate_csv
    mail(subject: 'Print Request from School Support',
      to: Setting.value_of('Print Request Email Address'),
      from: "#{@user.name} <#{@user.email}>")
  end
  
  def generate_csv
    require 'csv'
    CSV.generate do |csv|
      csv << ['ID', 'Last Name', 'First Name', 'Grade', 'Teacher']
      @export.students.each do |student|
        csv << [student.identifier, student.last_name, student.first_name, student.grade, student.users.first.try(:name)]
      end
    end
  end
  
end
