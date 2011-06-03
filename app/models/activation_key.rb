class ActivationKey < Base
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  def self.find_for_org(key)
    self.find(:all, :from => "#{AppConfig.candlepin.prefix}/owners/#{key}/activation_keys")
  end
  
  def poolCount
    @attributes['pools'].nil? ? 0 : @attributes['pools'].size()
  end

end
