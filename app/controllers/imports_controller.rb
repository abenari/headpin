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

class ImportsController < ApplicationController
  include OauthHelper
    
  navigation :subscriptions
  before_filter :require_user
  before_filter :require_org

  def section_id
    'subscriptions'
  end

  def index
    @imports = ImportRecord.find_by_org(working_org.key)
  end
  
  def create

    # Check if this request is a manifest upload:
    if params.has_key? :contents
      Rails.logger.info "Uploading a subscription manifest."
    
      begin
        temp_file = File.new(File.join("#{Rails.root}/tmp", "import_#{SecureRandom.hex(10)}.zip"), 'w+', 0600)
        temp_file.write params[:contents].read
        temp_file.close

        import = params[:contents]
        post_file "owners/#{working_org.key}/imports", 
                  File.new(temp_file.path)
      ensure
        File.delete temp_file.path
      end
    end
    redirect_to :action => :index

  end  
end
