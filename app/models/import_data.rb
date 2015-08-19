class ImportData < ActiveRecord::Base
  
  using_access_control
  
  attr_accessible :defaults, :model, :prompt_values, :user_id, :file,
    as: [:developer, :superintendent, :principal, :secretary, :teacher]
  
  serialize :model, Class
  serialize :prompt_values, Hash
  serialize :defaults, Hash
  
  belongs_to :user
  
  has_attached_file :file, path: '/import_files/:id/:filename'
    
  validates_presence_of :user
  validates_attachment :file, presence: true
  validate :model_import

  def self.for? model_or_record
    model_or_record = model_or_record.class unless model_or_record.is_a? Class
    model_or_record.has_import_options.present?
  end
  
  def prompt_values= values
    super values.reject { |key, value| value.blank? }
  end
  
  def defaults_and_prompt_values
    @defaults_and_prompt_values ||= {}.tap do |options|
      options.merge!(defaults) if defaults
      options.merge!(prompt_values) if prompt_values
    end
  end
  
  def options
    model.has_import_options
  end
  
  def prompts
    if options[:prompts].respond_to?(:call)
      options[:prompts].call()
    else
      options[:prompts]
    end || []
  end

  private

  def model_import
    unless ImportData.for? model
      errors.add :base, 'The selected model does not have import capabilities.'
    end
  end
  
end
