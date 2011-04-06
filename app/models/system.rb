class System < Base

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  # Candlepin calls this resource an owner:
  self.element_name = "consumer"

  # Candlepin API expects an owner key as the ID:
  self.primary_key = :uuid

end

