class ImportsController < ApplicationController
  navigation :subscriptions
  before_filter :require_user
  before_filter :require_org

  def section_id
    'imports'
  end

  def index
    @imports = ImportRecord.find_for_org(organization.key)
  end
end
