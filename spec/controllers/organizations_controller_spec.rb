require 'spec_helper'

describe OrganizationsController do

  include LoginHelperMethods

  before (:each) do
    login_user
  end

  it 'should display an index' do

    get 'index'
    response.should be_success

  end

end

