class Product < Base
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  def support_level
    return product_attribute(:support_level)
  end
  
  def arch
    return product_attribute(:arch)
  end  
  
  def product_attribute(key)
    if @product_attributes.nil?
      h = {}
      if @attributes['attributes']
        @attributes['attributes'].each do |attr|
          h[attr.name.to_sym]=attr.value
        end
      end
      @product_attributes = h      
    end
    return @product_attributes[key]
  end 
end