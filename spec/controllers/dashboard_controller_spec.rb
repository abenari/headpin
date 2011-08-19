require 'spec_helper'

describe DashboardController do
  include LoginHelperMethods
  render_views

  before (:each) do
    login_user
  end

  describe :index do
    it "should render the home page without any errors" do
      get :index
      response.should be_success
    end

   it "should still render if there is 0 pecent consumed percentage" do
     controller.stub!(:working_org).and_return(mock(Organization,
                               :subscription_consumed_stats => [],
                               :total_subscription_stats => [], 
                               :displayName => "ggg", 
                               :subscriptions_summary => {:available => 0},
                               :subscription_percent_consumed_stats => [],
                               :system_count => 0,
                               :guest_count => 0,
                               :key => 5
                               ))
     get :index
     response.should be_success
   end
  end

end
