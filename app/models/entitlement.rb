class Entitlement < Base
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  def startDate
    Date.parse @attributes['startDate']
  end
  
  def endDate
    Date.parse @attributes['endDate']
  end 
  
end
