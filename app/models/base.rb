require 'oauth_active_resource'
require 'candlepin_api'

# See http://www.quarkruby.com/2008/3/11/consume-non-rails-style-rest-apis
# for much of the detils behind this method
#class CandlepinObject < ActiveResource::Base
class Base < OAuthActiveResource::Resource

  self.site = "https://#{AppConfig.candlepin.host}:#{AppConfig.candlepin.port}#{AppConfig.candlepin.prefix}"
  self.format = :json

  class << self

    # Returns a Candlepin API object from the Ruby client API we use. Useful
    # for some odd situations but try to lean on the Active Resource models
    # and connection instead, whenever possible.
    def candlepin_api
      OauthCandlepinApi.new(Thread.current[:request].env['warden'].user,
        AppConfig.candlepin.oauth_key, AppConfig.candlepin.oauth_secret,
        {:host => AppConfig.candlepin.host, :port => AppConfig.candlepin.port})
    end

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
      return "#{prefix(prefix_options)}#{collection_name}/#{id}" << \
        "#{query_string(query_options)}"
    end

    def collection_path(prefix_options = {}, query_options = nil)
      prefix_options, query_options = split_options(prefix_options) \
        if query_options.nil?
      return "#{prefix(prefix_options)}#{collection_name}" << \
        "#{query_string(query_options)}"
    end

    def new_element_path(prefix_options = {})
      # TODO: This new doesn't look like it matches anything in Candlepin:
      "#{prefix(prefix_options)}#{collection_name}/new"
    end

  end

  def encode(options={})
    self.class.format.encode(attributes, options)
  end
end

