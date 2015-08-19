module Caching
  
  # Cache path is generated from the name of the model, the timestamp of the
  # most recently updated row, and a hash of the ids of the collection.
  #
  # The cache path is calculated in this way to prevent the following:
  # - incorrect presentation when records have been deleted
  # - incorrect presentation when records have been updated
  # - incorrect presentation when records are not present in the set
  # 

  def self.included base
    base.caches_action :index,
      layout: false,
      cache_path: proc { |controller|
        column = controller_model.respond_to?(:cache_key_timestamp_column) ? controller_model.cache_key_timestamp_column : :updated_at
        
        # Reorder is safe because params is appended to digest source string
        collection = find_collection.reorder(nil)
        
        sql = collection.select([:id, column].map{|c| "#{controller_model.table_name}.#{c}"}).to_sql
        string = ActiveRecord::Base.connection.execute(sql).to_a.to_s
        string << params.to_s
        "#{controller_model.model_name.cache_key}-#{Digest::SHA1.hexdigest(string)}"
      }
    base.helper_method :offset_amount
  end
  
  def offset_amount
    params[:print] ? nil : default_offset_amount
  end
  
  def default_offset_amount
    ENV['PAGE_OFFSET_AMOUNT'].to_i
  end

end