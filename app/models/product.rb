#
# Copyright 2011 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

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