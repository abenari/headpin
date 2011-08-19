module MockHelperMethods

  def mock_org key=nil, displayName=nil
    key ||= random_string
    displayName ||= random_string
    # TODO: this is sufficient for an org as far as we're concerned, but an
    # actual org queried from Candlepin will have many other properties:
    mock(Organization, :key => key, :displayName => displayName)
  end

  def real_org
    #since admin has many....
    Organization.find_by_user("admin")[0]
  end

  def random_string(prefix=nil)
    prefix ||= ''
    "#{prefix}#{rand(100000)}"
  end

end
