require 'spec_helper'

describe SystemsController do
  include LoginHelperMethods
  include MockHelperMethods
  render_views

  before (:each) do
    login_user
  end

  describe "GET index" do

    it 'should be successful' do
      org = real_org
      #Organization.should_receive(:find).with(:all, anything()).and_return([org])
      #Organization.should_receive(:find).with(org.key).and_return(org)
      #System.should_receive(:find).with(:all, {:params => {:owner => org.key,
      #  :type => :system}}).and_return([mock_system])

      # Get index, simulate session setting for the current organization:
      get 'index', {}, {:current_organization_id => org.key}
      response.should be_success
    end

    context 'with no working org selected' do
      it 'should redirect to org selection' do
        org = real_org
        #Organization.should_receive(:find).with(:all, anything()).and_return([org])
        # Get index, no current org in the session:
        controller.working_org.should be_nil
        get 'index'
        controller.working_org.key.should == org.key
        response.should be_success
      end
    end

  end


end

