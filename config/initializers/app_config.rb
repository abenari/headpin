# Note: Rails 3 loads initializers in alphabetical order therefore configuration objects 
# are not available in all initializers starting with 'a' letter.
require 'ostruct'
require 'yaml'
 
module ApplicationConfiguration

  class Config
    include Singleton

    attr_reader :config_file

    def initialize 
      @config_file = "/etc/sam/headpin.yml"
      @config_file = "#{Rails.root}/config/headpin.yml" unless File.exists? @config_file

      config = YAML::load_file(@config_file) || {}
      @ostruct = hashes2ostruct(config)
    end

    # helper method that converts object to open struct recursively
    def hashes2ostruct(object)
      return case object
      when Hash
        object = object.clone
        object.each do |key, value|
          object[key] = hashes2ostruct(value)
        end
        OpenStruct.new(object)
      when Array
        object = object.clone
        object.map! { |i| hashes2ostruct(i) }
      else
        object
      end
    end

    def to_os
      @ostruct
    end

  end
end

# singleton object itself (to access custom methods)
::AppConfigObject = ApplicationConfiguration::Config.instance

# config as open struct
::AppConfig = ApplicationConfiguration::Config.instance.to_os
