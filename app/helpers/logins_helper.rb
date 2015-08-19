module LoginsHelper
  
  SORTS[:logins] = {}
  
  FIELDS[:logins] = {
    index: [:email, :created_at],
    show: { fields: [] },
    form: { fields: [] }
  }
  
end
