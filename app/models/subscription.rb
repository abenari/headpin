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
    @product ||= Product.find(URI.escape(self.productId))
    return @product
  end 
  
  def consumed_stats
    @stats = Statistic.find_by_org(self.owner.key, :type => Statistic::PERPOOL, :reference => self.id)
    @stats.select do |stat|
      stat.valueType == "CONSUMED"
    end
  end
  
end
