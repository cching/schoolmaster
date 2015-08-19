class Setting < ActiveRecord::Base
  
  using_access_control
  
  attr_accessible :key, :value, as: :developer
  
  validates_presence_of :key, :value
  validates_uniqueness_of :key
  before_save :delete_from_cache
  after_save :write_to_cache
  before_destroy :delete_from_cache
  
  def self.value_of key
    Rails.cache.fetch(cache_key_for(key)) do
      where(key: key).first.try(:value)
    end
  end
  
  def name
    key
  end
  
  private
  
  def self.cache_key_for key
    "settings/#{key}"
  end
  
  def delete_from_cache
    Rails.cache.delete(self.cache_key_for(key_was))
  end
  
  def write_to_cache
    Rails.cache.write(self.cache_key_for(key), value)
  end
  
end
