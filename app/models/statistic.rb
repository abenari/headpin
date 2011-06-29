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

class Statistic < Base
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming


  PERPOOL = "PERPOOL"
  TOTALCONSUMER = "TOTALCONSUMERS"
  TOTALSUBSCRIPTIONCOUNT = "TOTALSUBSCRIPTIONCOUNT"
  TOTALSUBSCRIPTIONCONSUMED = "TOTALSUBSCRIPTIONCONSUMED"
  
  def self.find_by_org(key, options={})
    url = "#{AppConfig.candlepin.prefix}/owners/#{key}/statistics"
    url += "/#{options[:type]}" if options[:type]
    puts url
    #self.find(:all, :from => url, :params => options)
    self.find(:all, :from => url, :params => options)    
  end
  

  
end
