require 'spec_helper'

describe Organization do
  describe 'name validation' do

    it 'should allow a key and non-# name' do
      Organization.new(:key => 'foo88', :displayName => 'barrr').should be_valid
    end

    it 'should not allow "#" to be the first character of the name' do
      Organization.new(:key => '73798', :displayName => '#foo').should_not be_valid
    end

    it 'should not allow "#" to be in the middle of the name' do
      Organization.new(:key => 'ufe9vej9', :displayName => 'bar#camp').should_not be_valid
    end

    it 'should not allow "/" to be the first character of the name' do
      Organization.new(:key => '98d9s', :displayName => '/var').should_not be_valid
    end

    it 'should not allow "/" to be in the middle of the name' do
      Organization.new(:key => 'asjd0', :displayName => 'Batman/Superman').should_not be_valid
    end

    it 'should not allow a nil key' do
      Organization.new(:displayName => 'foo').should_not be_valid
    end

    it 'should allow spaces in the organization name' do
      Organization.new(:key => '987jidfoi', :displayName => 'Foo, Inc.').should be_valid
    end
  end

  describe '#new?' do
    
    it 'should be considered new if "id" is nil but "key" is not' do
      Organization.new(:key => 'something').should be_new
    end

    it 'should not be considered new if "id" not nil' do
      Organization.new(:key => 'foo', :id => 6).should_not be_new
    end

  end
end
