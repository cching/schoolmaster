class StudentsController < ApplicationController
  
  def export
    student_ids = collection.limit(nil).pluck(:id) - current_user.export_list_student_ids
    insert_student_ids_into_export_list_items student_ids
    render json: export_list_count_and_styles
  end
  
  def find_collection
    default = super.includes(:users).order('students.last_name')
    if grade = option_filter_value('grade')
      default = default.where(grade: grade)
    end
    if teacher = option_filter_value('class')
      default = default.joins(:periods).where('periods.id' => teacher)
    end
    if term = option_filter_value('term')
      if term == 'With No Period'
        default.with_no_period
      else
        default.joins(:periods).where(periods: { term: term })
      end
    else
      default
    end
  end
  
  def test_scores
    @student.initialize_interventions
  end

end
