class SubscriptionsController < ApplicationController

  navigation :subscriptions
  before_filter :require_user 
  before_filter :require_org

  def section_id
    'current'
  end

  def index
    @subscriptions = Subscription.find(:all, :params => { :owner => working_org.org_id })
    @subscriptions.sort! { |a,b| a.productName <=> b.productName }
  end

end
