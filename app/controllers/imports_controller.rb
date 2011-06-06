class ImportsController < ApplicationController
  include OauthHelper
    
  navigation :subscriptions
  before_filter :require_user
  before_filter :require_org

  def section_id
    'imports'
  end

  def index
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
        puts post_file "owners/#{working_org.key}/imports", 
                  File.new(temp_file.path)
      ensure
        File.delete temp_file.path
      end
    end
    redirect_to :action => :index

  end  
end
