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

require 'oauth_active_resource'

# See http://www.quarkruby.com/2008/3/11/consume-non-rails-style-rest-apis
# for much of the detils behind this method
#class CandlepinObject < ActiveResource::Base
class Base < OAuthActiveResource::Resource

  TRUE_VALUES = [true, 1, "1", "true", "yes", "TRUE", "YES", "T", "t", "Y", "y"]
  
  self.site = "https://#{AppConfig.candlepin.host}:#{AppConfig.candlepin.port}#{AppConfig.candlepin.prefix}"
  self.format = :json

  class << self

    def oauth_connection
      consumer_token = OAuth::Consumer.new(AppConfig.candlepin.oauth_key,
                                           AppConfig.candlepin.oauth_secret,
                                           {:site => site})
      OAuth::AccessToken.new(consumer_token)
    end

    def headers
      # Pulling the current request here - this is the
      # hack in ApplicationController
      user = Thread.current[:request].env['warden'].user
      user.nil? ? {} : { 'cp-user' => user.username }
    end

    # Active record tries to use the format in the URL (resource.json), overriding
    # these path methods allows us to match the Candlepin URL structure instead.
    def element_path(id, prefix_options = {}, query_options = nil)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}#{collection_name}/#{URI.escape id.to_s}#{query_string(query_options)}"
    end

    def collection_path(prefix_options = {}, query_options = nil)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}#{collection_name}#{query_string(query_options)}"
    end

#    def new_element_path(prefix_options = {})
      # TODO: This new doesn't look like it matches anything in Candlepin:
#      raise 'test here'
#      "#{prefix(prefix_options)}#{collection_name}/new"
#    end

  end

#  def encode(options={})
#    raise "encode"
#    self.class.format.encode(attributes, options)
#  end
  
  def created
    DateTime.parse @attributes['created']
  end
  
#  def updated
#    raise "uupdated"
#    DateTime.parse @attributes['updated']    
#  end
end

