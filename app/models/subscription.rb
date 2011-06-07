class Subscription < Base

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  # Our subscription is actually a pool in the Candlepin API:
  self.element_name = "pool"
  
  def startDate
    Date.parse @attributes['startDate']
  end
  
  def endDate
    Date.parse @attributes['endDate']
  end 
  
  def product
    @product ||= Product.find(self.productId)
    return @product
  end 
  
end
