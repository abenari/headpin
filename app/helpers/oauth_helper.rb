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

module OauthHelper

   def site
    "https://#{AppConfig.candlepin.host}:#{AppConfig.candlepin.port}"
  end 

  def post_file(uri, file)
    uri = "#{AppConfig.candlepin.prefix}/#{uri}"

    response = client(uri)[uri].post(:import => file)
    JSON.parse(response.body) unless response.body.empty?
  end

  # OAuth implementation of this method creates a new REST resource for
  # each request to do the signing and add appropriate headers.
  def client(uri)
    params = {
      :site => site,
      :http_method => :post,
      :request_token_path => "",
      :authorize_path => "",
      :access_token_path => ""}

    consumer = OAuth::Consumer.new(AppConfig.candlepin.oauth_key,
      AppConfig.candlepin.oauth_secret, params)
    request = Net::HTTP::Post.new("#{site}#{uri}")
    consumer.sign!(request)
    headers = {
      'Authorization' => request['Authorization'],
      # TODO:  This should be moved to a new helper - this is quite ugly
      'cp-user' => Thread.current[:request].env['warden'].user
    }

    # Creating a new client for every request:
    RestClient::Resource.new(site, :headers => headers)
  end


end
