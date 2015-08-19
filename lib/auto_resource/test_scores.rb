module TestScores
  
  def self.included base
    base.helper_method :data_order_statement_regex, :level_column_for, :score_column_for, :level_column?
  end
  
  # Convert column to level column
  def level_column_for column
    level_column?(column) ? column : "#{column}lv"
  end
  
  # Convert column to score column
  def score_column_for column
    (match = level_column?(column)) ? match[:score_column] : column
  end
  
  # Test whether the column is a level column.
  def level_column? column
    /(?<score_column>.+)lv$/.match(column)
  end
  
end