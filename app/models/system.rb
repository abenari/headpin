require 'json'

class System < Base

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  # Candlepin calls this resource an owner:
  self.element_name = "consumer"

  # Candlepin API expects an owner key as the ID:
  self.primary_key = :uuid

  def bind(pool_id)
    path = "/candlepin/consumers/#{uuid}/entitlements?pool=#{pool_id}"
    results = connection.post(path, "", Base.headers)
    attributes = JSON.parse(results.body)[0]
    ent = Entitlement.new(attributes)
    return ent
  end

  def post(custom_method_name, options = {}, body = '')
    # Overriding the default to trim the .format off the end of the URLs:
    pp options
  end
end

