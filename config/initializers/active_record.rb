module ActiveRecord
  
  class Base
    
    # Specify a default, look below at cache_key for details.
    def self.cache_key_timestamp_column
      :updated_at
    end
  
    # Creates a singleton function called search that uses LIKE to search
    # through the given columns.
    def self.searches *columns
      define_singleton_method :search do |query|
        
        columns = columns.dup
        join_columns = columns.extract_options!
        finder = self
        column_count = columns.length + join_columns.values.flatten.length
        
        statement = columns.map do |column|
          "\"#{table_name}\".\"#{column}\" ILIKE ?"
        end.join(' OR ')
        
        statement += join_columns.map do |table, columns|
          finder = finder.joins(table)
          table = reflect_on_association(table).plural_name
          columns.map do |column|
            "\"#{table}\".\"#{column}\" ILIKE ?"
          end.join(' OR ')
        end.join(' OR ')
        
        finder.where(statement, *["%#{query}%"] * column_count)
      end
    end
  
    # Relations that can be termed extend this.
    module WithTermExtension
      def with_term term = Term.current
        if proxy_association.reflection.klass == Period
          where(term: term)
        else
          joins(:periods).where(periods: { term: term })
        end
      end
    end
  
  end
  
  class Relation
    
    # Returns a cache key for the given relation. Calculated by retreiving the
    # most recent updated at timestamp.
    def cache_key
      column_name = "#{table_name}.#{cache_key_timestamp_column}"
      latest_time = order(column_name).limit(1).pluck(:updated_at).first
      "#{model_name.cache_key}-#{latest_time.try(:to_s, :number)}"
    end
    
  end
  
end