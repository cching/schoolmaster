class ImportJob
  
  @queue = :import
  
  attr_accessor :import_data
  
  delegate :model, :defaults, :prompt_values, :defaults_and_prompt_values, :update_ids, :user, to: :import_data
  
  def self.perform id
    ImportJob.new(id)
  end
  
  def initialize id
    @import_data = ImportData.find(id)
    Authorization.current_user = user
    create_records
    import_data.destroy
  rescue => error
    Rails.logger.info "[import file error] #{error.message}"
    Rails.logger.info error.backtrace.join("\n")
    raise error
  ensure
    cleanup
  end
  
  def cleanup
    Authorization.current_user = nil
    without_access_control do
      ImportData.where('created_at < ?', 1.day.ago).destroy_all
      if Resque::Failure.count > 200
        Resque.redis.ltrim(:failed, -1, -200)
      end
    end
  end
  
  def parser
    options[:parser] || CsvParser
  end
  
  def processor
    options[:processor]
  end
  
  def options
    model.has_import_options
  end
  
  def file
    @file ||= begin
      require 'open-uri'
      open(import_data.file.url)
    end
  end
  
  private
  
  def create_records
    current_role = user.role_symbols.first
    errors = []
    parser.read(file) do |hash, index|
      begin
        Authorization.current_user = user
        process(hash = hash.with_indifferent_access)
        record = new_record(hash)
        record.assign_attributes(hash, as: current_role)
        record.save!
      rescue => error
        errors << "Row #{index}: #{error.message}"
      ensure
        ActiveRecord::Base.connection.close
      end
    end
    raise errors.join("\n") if errors.any?
  end
  
  def process hash
    hash.reverse_merge!(defaults_and_prompt_values)
    processor.call(hash, @import_data) if processor.respond_to?(:call)
    if options[:associate].present?
      options[:associate].each do |record, field|
        if (value = hash.delete(record)) && !hash.has_key?(:"#{record}_id")
          finder = record.to_s.camelize.constantize
          
          # Handle methods that are specially defined for finding by a certain
          # field. Example: User has find_by_name because the actual columns
          # are last_name and first_name.
          attempted = if finder.respond_to?("find_by_#{field}")
            finder.send("find_by_#{field}", value)
          else
            finder.where(field => value).first
          end
          raise "Could not find the #{record} where #{field} = '#{value}'" unless attempted
          hash[:"#{record}_id"] = attempted.id
        end
      end
    end
  end
  
  def new_record hash
    options[:identify_with].each do |identifier, scopes|
      if hash[identifier]
        finder = model
        Array.wrap(scopes).compact.each do |scope|
          if !hash[scope]
            raise ArgumentError, "To find a #{model.name.titleize.downcase} by" <<
              " #{identifier}, you must also enter a #{scope.to_s.humanize.downcase}"
          else
            finder = finder.where(scope => hash[scope])
          end
        end
        record = finder.where(identifier => hash[identifier]).first
        if record
          return record
        end
      end
    end
    model.new
  end
  
  def without_access_control
    previous_state = Authorization.ignore_access_control
    Authorization.ignore_access_control(true)
    result = yield
  ensure
    Authorization.ignore_access_control(previous_state)
    result
  end

end