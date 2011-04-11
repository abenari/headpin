require 'spec_helper'

describe OrganizationsController do

  include LoginHelperMethods
  include MockHelperMethods

  before (:each) do
    login_user
  end

  describe "GET index" do

    context 'with no existing organizations' do

      it 'should be successful' do
        Organization.should_receive(:find).with(:all).and_return([])
        get 'index'
        response.should be_success
      end

    end

  end

  describe "GET new" do
    it 'should be successful' do
      get 'new'
      response.should be_success
    end
  end

  describe "POST create" do

    it 'should create a new organization' do
      org = mock_org()
      org.should_receive(:save).and_return(true)
      Organization.stub!(:new).and_return org

      post 'create', :organization => {:key => '', :displayName => ''}
      response.should redirect_to("http://test.host/organizations/#{org.key}")
    end
  end

end

