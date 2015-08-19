Schoolsupport::Application.routes.draw do

  mount Resque::Server.new, at: '/resque'

  # Helper function that adds 'import' and 'export' actions in addition to
  # resources.
  def helper *args
    resources *args do
      importable
      yield if block_given?
    end
  end
  
  # Extract import routes.
  def importable
    match 'import', on: :collection
  end
  
  # Extract export routes.
  def exportable
    match 'export' => 'export_list_items#select'
    match 'export/:export_kind(/:export_id)' => 'export_list_items#form'
  end
  
  def intervenable
    match 'new_intervention' => 'students#new_intervention', via: 'POST'
    match 'destroy_intervention' => 'students#destroy_intervention', via: 'POST'
  end
  
  def notable
    match 'new_student_note' => 'students#new_student_note', via: 'POST'
    match 'destroy_student_note' => 'students#destroy_student_note', via: 'POST'
  end
  
  # Districts, Schools, Periods, Students, Users, Tests
  def test_scores
    # The following to calls to helper are necessary to preference
    # "/test_scores/new" over "/test_scores/:id".
    helper :test_scores, only: :new
    scope as: 'new' do
      match 'test_scores/:student_id/new' => 'test_scores#new', via: 'GET', as: 'student_test_score'
    end
    helper :test_scores, only: [:index, :create] do
      collection do
        match 'help' => 'test_scores#help'
        match ':student_id/new_intervention' => 'students#new_intervention'
        match ':student_id/destroy_intervention' => 'students#destroy_intervention', via: 'POST'
        match ':student_id/new_student_note' => 'students#new_student_note'
        match ':student_id/destroy_student_note' => 'students#destroy_student_note', via: 'POST'
        match ':student_id/:id' => 'test_scores#edit', via: 'GET'
        match ':student_id/:id' => 'test_scores#update', via: 'PUT'
        match ':student_id/:id' => 'test_scores#destroy', via: 'DELETE'
        match ':id' => 'students#test_scores'
      end
      exportable
    end
  end
  def students
    helper :students do
      helper :periods do
        helper :users
        test_scores
      end
      helper :users
      intervenable
      notable
      exportable
    end
  end
  def periods
    helper :periods do
      helper :students do
        helper :users
        test_scores
        exportable
        intervenable
        notable
      end
      helper :users
      test_scores
    end
  end
  def users
    helper :users do
      helper :periods do
        helper :students do
          exportable
          intervenable
          notable
        end
        test_scores
      end
      helper :students do
        helper :periods
        exportable
        intervenable
        notable
      end
      test_scores
    end
  end
  def schools
    helper :schools do
      periods
      users
      students
      test_scores
    end
  end
  def districts
    helper :districts do
      helper :bus_stops
      helper :bus_routes
      schools
      users
      students
      test_scores
    end
  end

  districts
  schools
  periods
  students
  users
  test_scores
  
  # Bus Routes and Stops
  helper :bus_stops
  helper :bus_routes
  
  # Templates, Pdfs, Types, Fields, Fonts, Settings, Logins
  resources :templates do
    resources :pdfs do
      resources :types do
        resources :schools
      end
    end
    resources :fields
  end
  resources :fonts
  resources :settings
  resources :logins, only: :index
  
  # Export List Items
  match 'export_list_items' => 'export_list_items#index'
  match 'export_list_items/waiting' => 'export_list_items#waiting'
  match 'export_list_items/inline' => 'export_list_items#inline'
  match 'export_list_items/download/:id' => 'export_list_items#download', :via => 'GET', :as => 'download_export'
  match 'export_list_items/upload' => 'export_list_items#upload'
  match 'export_list_items/export/view_request' => 'export_list_items#view_request'
  match 'export_list_items/toggle' => 'export_list_items#toggle', via: 'POST'
  match 'export_list_items/clear' => 'export_list_items#clear', via: 'POST'
  match 'export_list_items/export' => 'export_list_items#select'
  match 'export_list_items/export/:export_kind(/:export_id)' => 'export_list_items#form'
  
  # Help
  match 'help' => 'help#index'
  match 'help/*path' => 'help#page'

  # Friendly user session names.
  match 'login' => 'user_sessions#new', via: :get
  match 'login' => 'user_sessions#create', via: :post
  match 'logout' => 'user_sessions#destroy'

  # Not used, but root has to point somewhere.
  root to: 'users#show'

end
