class SubscriptionsController < ApplicationController
  navigation :subscriptions
  before_filter :require_user 
  before_filter :require_org

  def index
    @subscriptions = Subscription.find(:all, 
      :params => {:owner => organization.attributes['id']})
    @imports = ImportRecord.find_for_org(organization.key)
  end

  def create

    # Check if this request is a manifest upload:
    if params.has_key? :contents
      Rails.logger.info "Uploading a subscription manifest."
      temp_file = nil
      temp_file = File.new(File.join("#{Rails.root}/tmp", "import_#{SecureRandom.hex(10)}.zip"), 'w+', 0600)
      temp_file.write params[:contents].read
      temp_file.close
      organization.import(File.expand_path(temp_file.path))
    end


  end
end
