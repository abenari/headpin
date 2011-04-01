#require 'mappings'
# See http://www.quarkruby.com/2008/3/11/consume-non-rails-style-rest-apis
# for much of the detils behind this method
class CandlepinObject < ActiveResource::Base

  self.site = 'https://localhost:8443/candlepin/'
  self.user = 'admin'
  self.password = 'admin'
  self.format = :json

  # TODO: probably don't want to ship with this. :)
  self.ssl_options = {
    :ca_file => "/etc/candlepin/certs/candlepin-ca.crt",
    :verify_mode => OpenSSL::SSL::VERIFY_NONE
  }

  class << self

    # Active record tries to use the format in the URL (resource.json), overriding
    # these path methods allows us to match the Candlepin URL structure instead.
    def element_path(id, prefix_options = {}, query_options = nil)
      prefix_options, query_options = split_options(prefix_options) \
          if query_options.nil?
      return "#{prefix(prefix_options)}#{collection_name}/#{id}" << \
        "#{query_string(query_options)}"
    end
    def collection_path(prefix_options = {}, query_options = nil)
      prefix_options, query_options = split_options(prefix_options) \
        if query_options.nil?
      return "#{prefix(prefix_options)}#{collection_name}" << \
        "#{query_string(query_options)}"
    end

  end

  def encode(options={})
    self.class.format.encode(attributes, options)
  end


end
