module ExportListItemsHelper
  
  SORTS[:export_list_items] = {
    identifier: 'students.identifier',
    name: 'students.last_name',
    grade: 'students.grade'
  }
  
  FIELDS[:export_list_items] = {
    index: [:identifier, :name, :grade, :teacher]
  }
  
  PARENTS[:export_list_items] = [Student]
  
  def export_selected_students_count
    count = find_first_parent.is_a?(Student) ? 1 : @export_data.student_ids.count
    pluralize(count, 'student') + ' selected.'
  end
  
  def export_form_options
    options = {}
    options[:url] = request.path
    options[:html] = { target: '_blank' } unless @export_data.is_request?
    options
  end
  
  # The title to display under 'PRINT'.
  def export_title
    if params[:export_kind]
      if @export_data.kind == 'print'
        @export_data.type.name
      else
        @export_data.kind.titleize
      end
    else
      if params[:id]
        controller_name.singularize
      else
        controller_name
      end.titleize
    end
  end
  
  # Which templates to show to the current user as options.
  def available_types
    @available_types ||= School.with_permissions_to(:show).includes(:types).order('types.name').map(&:types).flatten
  end
  
end