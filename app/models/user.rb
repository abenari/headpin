
class User < Base
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  def persisted?
    false
  end
end
