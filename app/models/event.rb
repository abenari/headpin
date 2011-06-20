class Event < Base
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  def self.find_by_org(key)
    self.find(:all, :from => "#{AppConfig.candlepin.prefix}/owners/#{key}/events")
  end
  
  def self.find_by_consumer(key)
    self.find(:all, :from => "#{AppConfig.candlepin.prefix}/consumers/#{key}/events")
  end  
  
  def timestamp
    DateTime.parse @attributes['timestamp']
  end
  

end
