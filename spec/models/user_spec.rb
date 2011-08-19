require 'spec_helper'
describe User do
  describe 'new User validation' do
    it 'should be valid after creation' do
      User.new.should be_valid
    end

    it 'should be able to be made superAdmin' do
      u = User.new({:superAdmin => true})
      u.should be_valid
      u.superAdmin.should eql(true)
    end
  end
end
