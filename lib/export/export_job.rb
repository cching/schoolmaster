class ExportJob
  
  @queue = :export
  
  def self.perform export_data_id
    ExportJob.new(export_data_id)
  end
  
  def initialize export_data_id
    @export_data = ExportData.find(export_data_id)
    Authorization.current_user = @export_data.user
    if @export_data.kind == 'request'
      RequestMailer.request_form(@export_data).deliver
      @export_data.destroy
    else
      file_name = Rails.root.join('tmp', "#{@export_data.id}." + "#{@export_data.format}");

      File.open(file_name, 'wb') do |file|
        if @export_data.kind == 'print'
          Print.new(@export_data, file.path).generate
        elsif @export_data.kind == 'zpass'
          Zpass.new(@export_data, file.path).generate
        end
        @export_data.file_file_name = file
        @export_data.save
      end
    end
  rescue => error
    Rails.logger.info "[export error] #{error.message}"
    Rails.logger.info error.backtrace.join("\n")
    raise error
  ensure
    cleanup
  end
  
  def cleanup
    Authorization.current_user = nil
    
    prev = Authorization.ignore_access_control
    Authorization.ignore_access_control(true)
    
    ExportData.where('created_at < ?', 1.day.ago).destroy_all
    if Resque::Failure.count > 200
      Resque.redis.ltrim(:failed, -1, -200)
    end
    
    Authorization.ignore_access_control(prev)
  end
  
  # What kind are accepted.
  def self.kinds
    %w(print request zpass)
  end
  
  # What template columns are images.
  def self.image_columns
    %w(image school_mascot_image image_if_present)
  end
  
  def self.necessary_image_columns
    %w(image school_mascot_image)
  end
  
  # What template columns are colors.
  def self.color_columns
    %w(bus_route_color_value)
  end
  
end