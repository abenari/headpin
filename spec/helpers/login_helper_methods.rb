module LoginHelperMethods

  # Mock a logged in warden user:
  def login_user user=nil
    @mock_user = user || "admin"
    request.env['warden'] = mock(Warden, :user => @mock_user, :authenticate => @mock_user, :authenticate! => @mock_user)
  end

end
