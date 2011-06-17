class Statistic < Base
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming


  PERPOOL = "PERPOOL"
  
  def self.find_for_org(key, options={})
    url = "#{AppConfig.candlepin.prefix}/owners/#{key}/statistics"
    url += "/#{options[:type]}" if options[:type]
    puts url
    #self.find(:all, :from => url, :params => options)
    self.find(:all, :from => url, :params => options)    
  end
  

  
end
