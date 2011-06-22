
class User < Base
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  self.primary_key = :username
  
  def initialize(attrs={})
    attrs[:superAdmin]= TRUE_VALUES.include?(attrs[:superAdmin])
    super(attrs)
  end
  
  schema do
    string 'username', 'password', "superAdmin"
  end
  
  def superAdmin=(value)
    attrs[:superAdmin]= TRUE_VALUES.include?(value)    
  end
end
