class ImportRecord < Base
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  def timestamp
    DateTime.parse @attributes['updated']
  end

  def self.find_by_org(key)
    self.find(:all, :from => "#{AppConfig.candlepin.prefix}/owners/#{key}/imports")
  end

end
