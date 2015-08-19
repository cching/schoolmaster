module TestScoresHelper
  
  PARENTS[:test_scores] = [Student, Period, User, School, District]
  
  FIELDS[:test_scores] = {
    form: {
      fields: [:test_name, [:term, collection: Term.choices]],
      relations: [[:student, as: :search_select, include_blank: true]]
    }
  }
  
  def full_level_name abbr
    case abbr
    when 'fbb'
      'Far Below Basic'
    when 'bbasic'
      'Below Basic'
    when 'prof'
      'Proficient'
    when 'adv'
      'Advanced'
    else
      abbr.titleize
    end
  end
  
  def class_options
	  @teacher_options ||= if controller_model == TestScore || controller_model == Student
	    scope = find_first_parent ? find_first_parent.students : Student
	    scope = scope.with_permissions_to(:show)
	    sql = scope.joins(:periods).order('periods.name').uniq.select('periods.*').to_sql
	    teachers = Period.find_by_sql(sql).map { |t| [t.name, t.id]}
      selected = params[:class].present? ? params[:class] : 'All'
	    options_for_select(['All'] + teachers, selected)
   end
	end
	
	def grade_options
	 @grade_options ||= if controller_model == Student || controller_model == TestScore
	   grades = if controller_model == Student
	     options_scope.uniq.pluck('students.grade')
	   elsif controller_model == TestScore
	     options_scope.joins(:student).uniq.pluck('students.grade')
     end
     selected = params[:grade].present? ? params[:grade] : 'All Grades'
	   grades.sort_by!(&:to_i)
	   grades.map! do |grade|
	     [pretty_grade(grade), grade]
     end
	   options_for_select(['All'] + grades, selected)
   end
	end
	
	def subject_options
	  options_for_select(%w(ELA Math))
	end
  
  def group_levels students
    if @leveled
      students.group_by do |student|
        grouper = nil
        student.test_scores.each do |score|
          if @ordered && score.test_name == @ordered[:test_name] && score.term == @ordered[:term]
            grouper = score.data[level_column_for(@ordered[:key])]
            break
          end
        end
        grouper.present? ? grouper : 'unknown'
      end
    else
      [[nil, students]]
    end
  end
  
  def group_tests test_scores
    hash = {}
    grouped = test_scores.group_by(&:test_name)
    grouped.each do |test_name, test_scores|
      hash[test_name] = {}
      test_scores.sort_by!(&:term).each_with_index do |score, index|
        score.data.each do |key, value|
          if !level_column?(key) && (index == test_scores.length - 1 || key !~ /_rc/)
            header = key.gsub(/#{test_name}_?/i, '')
            header = "#{header.titleize}<br />#{Term.shorten(score.term)}"
            hash[test_name][header] = {
              level: score.data[level_column_for(key)],
              score: value,
              id: score.id
            }
          end
        end
      end
    end
    hash.to_a.sort_by(&test_name_sort)
    end
  end
  
  def data_columns options = {}
    @data_columns ||= begin
      Rails.cache.fetch("/test_scores/data_columns/#{data_columns_cache_key}", options) do
        data_columns = {}
        
        coll = find_collection(true)
          .limit(nil).offset(nil)
          .select('students.id')
        
        coll = TestScore.uniq.where({
          student_id: coll
        }).select('test_name, term, skeys(data)')
      
        coll = coll.where({
          term: params[:term]
        }) if params[:term].present? && params[:term] != 'All'
      
        coll = coll.where({
          test_name: params[:test_name]
        }) if params[:test_name].present? && params[:test_name] != 'All'
      
        TestScore.connection.execute(coll.to_sql).to_a.each do |score|
          test_name = score['test_name']
          term = score['term']
          data_columns[test_name] ||= {}
          data_columns[test_name][term] ||= Set.new
          data_columns[test_name][term] << score['skeys']
        end
        data_columns
      end
    end
  end
  
  def data_columns_cache_key
    sql = find_collection(true)
      .joins('LEFT OUTER JOIN test_scores ON students.id = test_scores.student_id')
      .limit(nil).offset(nil).reorder(nil)
      .select('test_scores.id, test_scores.updated_at').to_sql
    string = ActiveRecord::Base.connection.execute(sql).to_a.to_s
    Digest::SHA1.hexdigest(string)
  end
  
  def score_columns
    @score_columns ||= begin
      score_columns = {}
      data_columns.each do |test_name, terms_and_keys|
        
        if (@selected_subject == 'ELA' && test_name =~ /math/i) ||
          (@selected_subject == 'Math' && test_name !~ /math/i)
            next
        end
        
        terms_and_keys = terms_and_keys.to_a.sort_by do |(term, keys)|
          term
        end
        
        score_columns[test_name] ||= {}
        terms_and_keys.each do |term, keys|
          
          # If there is a key named the same as the test, return only that key.
          # Set @leveled to whether the data is ordered by that single key.
          score_columns[test_name][term] = if key = keys.grep(/^#{test_name}$/i).first
            if matches_current_order(test_name, term, key) && keys.include?(level_column_for(key))
              @leveled = true
            end
            [key]
            
          else
            
            # Return all non level or report cluster keys.
            keys.reject do |key|
              
              # Check to see if the current ordered column is leveled.
              if matches_current_order(test_name, term, key) && keys.include?(level_column_for(key))
                @leveled = true
              end
              level_column?(key) || key =~ /_rc/
            end.sort
          end
        end
      end
      score_columns.sort_by(&test_name_sort)
    end
  end
  
  def test_score_indices
    @test_score_indices ||= begin
      test_score_indices, index = {}, 0
      score_columns.each do |test_name, terms_and_keys|
        test_score_indices[test_name] = {}
        terms_and_keys.each_key do |term|
          test_score_indices[test_name][term] = index
          index += 1
        end
      end
      @test_score_count = index + 1
      test_score_indices
    end
  end
  
  def test_score_count
    @test_score_count || (test_score_indices && @test_score_count)
  end
  
  def associated_test_scores test_scores
    hash = {}
    test_scores.each do |score|
      hash[[score.test_name, score.term]] = score
    end
    yield(hash)
  end
  
  def data_column_attributes test_name, term, key
    classes = ''
    if matches_current_order(test_name, term, key)
      classes << ' sorted'
      classes << ' reverse' if @ordered[:direction] == 'desc'
    end
    
    # Sort by level if we can.
    if data_columns[test_name][term].include?(level_column_for(key))
      key = level_column_for(key)
    end
    
    %(data-order-by="#{[test_name, term, key].join(' ')}" class="replace sortable small#{classes}").html_safe
  end
  
  def matches_current_order test_name, term, key
    @ordered && test_name == @ordered[:test_name] &&
      term == @ordered[:term] && key == score_column_for(@ordered[:key])
  end
  
  def pretty_grade grade
    grade =~ /\d+/ ? grade.to_i.ordinalize : grade
  end
  
  def test_scores_option_filters
    filters = %w(subject grade class intervention english_learner hispanic socioeconomically_disadvantaged)
    filters -= ['socioeconomically_disadvantaged'] if hide_socioeconomic_status
    filters
  end
  
  def test_scores_form_path
    if action_name == 'new'
      '/test_scores'
    else
      request.path
    end
  end
  
  private
  
  def test_name_sort
    Proc.new do |(test_name, scores)|
      case test_name
      when /^ela$/i then 'A'
      when /ela/i then 'AA'
      when /^celdt/i then 'AAA'
      when /^math$/i then 'AAAA'
      when /math/i then 'AAAAA'
      else
        test_name
      end
  end
  
end
