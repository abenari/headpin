class SubscriptionsController < ApplicationController
  include OauthHelper

  navigation :subscriptions
  before_filter :require_user 
  before_filter :require_org

  def index
    @subscriptions = Subscription.find(:all, :params => { :owner => working_org.org_id })
    @imports = ImportRecord.find_for_org(working_org.key)
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

  end
end
