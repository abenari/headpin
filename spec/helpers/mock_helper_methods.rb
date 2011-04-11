module MockHelperMethods

  def mock_org key=nil, displayName=nil
    key ||= random_string
    displayName ||= random_string
    mock(Organization, :key => key, :displayName => displayName)
  end

  def random_string(prefix=nil)
    prefix ||= ''
    "#{prefix}#{rand(100000)}"
  end

end
