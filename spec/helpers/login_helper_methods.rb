module LoginHelperMethods

  # Mock a logged in warden user:
  def login_user user=nil
    @username = user || "admin"
    stub_user = stub(Warden, :user => @username, :authenticate => @username, :authenticate! => @username)
    request.env['warden'] = stub_user
    Thread.current[:request] = request
  end

end
