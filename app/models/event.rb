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

class Event < Base
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  def self.find_by_org(key)
    self.find(:all, :from => "#{AppConfig.candlepin.prefix}/owners/#{key}/events")
  end
  
  def self.find_by_consumer(key)
    self.find(:all, :from => "#{AppConfig.candlepin.prefix}/consumers/#{key}/events")
  end  
  
  def timestamp
    DateTime.parse @attributes['timestamp']
  end
  

end
