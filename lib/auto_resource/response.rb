module Response
  
  # When included, have the controller respond to the following methods.
  # Necessary for respond_with to work.
  def self.included base
    base.respond_to :html, :json
  end
  
  private
  
  # If the action is update, create, or destroy, override default behavior to
  # respond with the appropriate json.
  def respond_with record
    case action_name
    when 'create', 'update'
      if record.errors.any?
        render json: failure_hash, content_type: 'text/plain'
      else
        render json: success_hash(record), content_type: 'text/plain'
      end
    when 'destroy'
      if record.errors.any?
        render json: destroy_failure_hash(record)
      else
        render json: destroy_success_hash(record)
      end
    else
      super
    end
  end
  
  # The object to return in case of a success.
  def success_hash record
    {}.tap do |hash|
      hash[:success] = true
      if record.is_a?(TestScore)
        @student = @test_score.student
        hash[:test_scores] = ERB::Util.html_escape(render_to_string('students/_tests'))
        if action_name == 'create'
          hash[:skip_path_reload] = true
          hash[:path] = "#{request.path}/#{@test_score.student_id}"
        end
      else
        hash[:page] = ERB::Util.html_escape(render_to_string(view_for(true)))
        hash[:path] = parent_path(record) unless record.is_a?(Intervention)
      end
      if (action_name == 'update' || action_name == 'create') && controller_name != 'test_scores'
        hash[:terms] = if record.class == Period
          ['All', record.term]
        elsif [Student, User].include?(record.class)
          ['All', 'With No Period'] + record.periods.pluck(:term)
        end
        hash[:row] = ERB::Util.html_escape(render_to_string('_row', layout: false))
      end
    end
  end
  
  # The object to return in case of a failure.
  def failure_hash
    {
      page: ERB::Util.html_escape(render_to_string(view_for(false))),
      success: false
    }
  end
  
  # Success object for destroy.
  def destroy_success_hash record
    {
      success: true,
      id: record.id
    }
  end
  
  # Failure object for destroy.
  def destroy_failure_hash record
    {
      success: false,
      page: ERB::Util.html_escape(render_to_string('show'))
    }
  end
  
  # Which view to render for the given action.
  def view_for success
    case action_name
    when 'update'
      success ? 'show' : 'edit'
    when 'create'
      success ? 'show' : 'new'
    end
  end
  
end