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
  
  def consumed_stats
    @stats = Statistic.find_for_org(self.owner.key, :type => Statistic::PERPOOL, :reference => self.id)
    @stats.select do |stat|
      stat.valueType == "CONSUMED"
    end
  end
  
end
