# Stores the default actions for a controller.
module Methods
  
  # Index action. Finds the collection and sets the collection variable.
  def index
    set_collection find_collection
    respond_with collection
  end
  
  # Import action.
  def import
    @import_data = ImportData.new((params[:import_data] || {}).merge({
      model: controller_model,
      defaults: params_with_parents(controller_model),
      user_id: current_user.id
    }), as: current_role)
    if params[:import_data] && @import_data.save
      @import_success = true
      Resque.enqueue(ImportJob, @import_data.id)
      load_import_jobs
      render json: {
        page: ERB::Util.html_escape(render_to_string('import'))
      }
    end
    load_import_jobs
  end

  # Show action.
  def show
    respond_with resource
  end

  # Edit action.
  def edit
    respond_with resource
  end
  
  # New Action.
  def new
    respond_with new_resource
  end

  # Create action. Save the resource created by declarative_authorization and
  # call respond_with.
  def create
    params[:id] = resource.id if resource.save
    respond_with resource
  end

  # Update action. Update the record attributes with params as the current
  # user.
  def update
    resource.update_attributes params[params_key], as: current_role
    respond_with resource
  end

  # Destroy action. Call destroy on the record and call respond_with.
  def destroy
    resource.destroy
    respond_with resource
  end

  private
  
  # Return the key that represents where the attributes for the current
  # resource are stored in params.
  #   controller_name # => 'users'
  #   params_key # => :user
  def params_key
    controller_name.singularize.to_sym
  end
  
  def load_import_jobs
    @pending_jobs ||= if Resque.peek('import') || Resque.working.any?
      pending_ids = Resque.peek('import', 0, 1000).map do |job|
        job['args'].first
      end
      pending_ids += Resque.working.map do |worker|
        if worker.job['queue'] == 'import'
          worker.job['payload']['args'].first
        end
      end.compact
      ImportData.with_permissions_to(:show).where(id: pending_ids).order('created_at desc')
    else
      []
    end
    
    @failed_jobs ||= if Resque::Failure.count > 0
      @failure_data = {}
      failed_ids = Resque::Failure.all(0, 100).map do |job|
        if job['queue'] == 'import'
          id = job['payload']['args'].first
          @failure_data[id] = job['error']
          id
        end
      end.compact
      ImportData.with_permissions_to(:show).where(id: failed_ids).order('created_at desc')
    else
      []
    end
  end
  
end