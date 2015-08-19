class TestScoresController < ApplicationController
  
  def find_collection without = false
    # Pass Student to super so it uses that instead of the inferred model
    # TestScore from the controller_name. Outer join with test_scores to be
    # able to order and select by those fields. Preload must be called
    # instead of includes or eager_load because rails must load the students
    # and then load the test_scores in another query for the last statement
    # in this method to work properly, otherwise only the ordered by test
    # score will be loaded.
    default = super(Student).preload(:test_scores).preload(:users)

    if default.to_sql !~ /periods_students/
      default = default
      .joins('LEFT OUTER JOIN periods_students ON students.id = periods_students.student_id')
    end
    
    default = default
    .joins('LEFT OUTER JOIN periods ON periods_students.period_id = periods.id')
    .joins('LEFT OUTER JOIN periods_users ON periods.id = periods_users.period_id')
    .joins('LEFT OUTER JOIN users ON periods_users.user_id = users.id')
    
    # Used by some methods to calculate the present columns so the where and
    # order clauses are not necessary.
    return default if without
    
    if grade = option_filter_value(:grade)
      default = default.where('students.grade' => grade)
    end

    if period = option_filter_value(:class)
      default = default.where('periods.id' => period)
    end
    
    %w(intervention english_learner hispanic socioeconomically_disadvantaged).each do |filter|
      if filter_value = option_filter_value(filter)
        filter = 'intervened' if filter == 'intervention'
        default = default.where("students.#{filter}" => filter_value)
      end
    end
    
    subject = option_filter_value(:subject)
    @selected_subject = subject == 'Math' ? 'Math' : 'ELA'
    
    if params[:order].blank?
      auto_sort_column = @selected_subject.downcase
      params[:order] = "#{auto_sort_column} #{Term.previous} #{level_column_for(auto_sort_column)} asc"
    end
    
    if params[:order].present? && order_match = data_order_statement_regex.match(params[:order])
      
      # Skip ordering if the test filter does not align with the
      # ordered column, otherwise no rows will match. Also nillify order_match
      # so all other code thinks there is no order.
      if @selected_subject &&
        ((@selected_subject == 'ELA' && order_match[:test_name] =~ /math/i) ||
        (@selected_subject == 'Math' && order_match[:test_name] !~ /math/i))
          order_match = nil
      else
        
        # If ordering by a level, create an order statement to order by
        # adv, prof, basic, bbasic, fbb or the opposite. If not ordering by a
        # level just order by the score key.
        score_order_statement = if level_column?(order_match[:key])
          levels = if order_match[:test_name] == 'celdt'
            TestScore::CELDT_LEVELS
          else
            TestScore::CST_LEVELS
          end
          levels.reverse! if order_match[:direction] == 'desc'
          levels.map do |level|
            "(test_scores.data -> :key) = '#{level}'"
          end.join(', ')
        else
          "lpad(test_scores.data -> :score_key, 10, '0') #{order_match[:direction]}"
        end
      
        # Order by the comparison of test_name and term because the key in
        # data will not be unique across different years or tests. Order by
        # is the value for the given key is NULL or '' so useful data always
        # appears at the top.
        default = default.order(ActiveRecord::Base.send(:sanitize_sql, [
          "test_scores.test_name = :test_name, " +
          "test_scores.term = :term, " +
          "((test_scores.data -> :key) IS NULL OR" +
          " (test_scores.data -> :key) = ''), " +
          score_order_statement,
        {
          test_name: order_match[:test_name],
          term: order_match[:term],
          score_key: score_column_for(order_match[:key]),
          key: order_match[:key]
        }], 'test_scores'))
      
        @ordered = order_match
      end
    end
    
    # Order by students last name after everything else so it does not
    # affect the overall order, but only when other order values are equal.
    default = default.order('users.last_name, students.last_name')
    
    # No join restriction is needed if the data is not ordered. Uniq is only
    # present here because duplicates are handled by the join restriction
    # below and uniq breaks the code below if included beforehand.
    if order_match
      
      default.joins("LEFT OUTER JOIN (#{
        TestScore.select('test_scores.*')
        .where(
          'test_scores.test_name = :test_name AND ' +
          'test_scores.term = :term',
        {
          test_name: order_match[:test_name],
          term: order_match[:term],
          key: order_match[:key]
        }).to_sql
      }) AS test_scores ON students.id = test_scores.student_id")
    else
      
      # Add order values to select because for DISTINCT, postgres requires
      # all values in ORDER BY to also be present in the SELECT clause.
      order_values = default.order_values.join(', ').gsub(/ (asc|desc)/, '')
      default.uniq.select('students.*').select(order_values)
      .joins('LEFT OUTER JOIN test_scores ON students.id = test_scores.student_id')
    end
  end
  
  # Method called by declarative authorization to authorize the current user
  # to load the show action. The actual record this page represents is a
  # student, but declarative authorization expects a test score so send it
  # one. Must override this method and not simply define "load_test_score"
  # because the filter_access_to is called from ApplicationController so
  # controller_name is "application", so declarative authorization calls
  # "load_application".
  def load_controller_object context
    if action_name == 'edit' || action_name == 'destroy' || action_name == 'update'
      super
    else
      @student ||= begin
        id = params[find_first_parent.is_a?(Student) ? :student_id : :id ]
        Student.find(id)
      end
      @test_score = TestScore.new({student_id: @student.id}, as: current_role)
    end
  end
  
  def show
    @student ||= Student.find(params[:student_id])
  end
  
  # Set to a higher value because it takes longer to create the index html for
  # test scores.
  def default_offset_amount
    50
  end
  
  def help
    
  end
  
  def new
    if params[:student_id]
      @test_score.student_id = params[:student_id]
    end
    @student = @test_score.student
    respond_with @test_score
  end
  
  private
  
  # Tests order by values in the form:
  #   Cst 2012-2013 math asc
  # The ^ and $ anchors are very important for protection against sql
  # injection attacks.
  def data_order_statement_regex
    /^(?<test_name>.+) (?<term>\d{4}-\d{4}) (?<key>.+) (?<direction>asc|desc)$/
  end
  
end
