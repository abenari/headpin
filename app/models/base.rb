require 'oauth_active_resource'

# See http://www.quarkruby.com/2008/3/11/consume-non-rails-style-rest-apis
# for much of the detils behind this method
#class CandlepinObject < ActiveResource::Base
class Base < OAuthActiveResource::Resource

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
      username = Thread.current[:request].env['warden'].user
      username.nil? ? {} : { 'cp-user' => username }
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

    def new_element_path(prefix_options = {})
      # TODO: This new doesn't look like it matches anything in Candlepin:
      "#{prefix(prefix_options)}#{collection_name}/new"
    end

  end

  def encode(options={})
    self.class.format.encode(attributes, options)
  end
  
  def created
    DateTime.parse @attributes['created']
  end
  
  def updated
    DateTime.parse @attributes['updated']    
  end
end

