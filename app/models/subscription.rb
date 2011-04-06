class Subscription < Base

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  # Our subscription is actually a pool in the Candlepin API:
  self.element_name = "pool"

end
