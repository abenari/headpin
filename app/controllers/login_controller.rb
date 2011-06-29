#
# Copyright 2011 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

class LoginController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  skip_before_filter :authorize, :only => [:new, :create, :destroy]

  def section_id
    "loginpage"
  end

  def index
    redirect_to new_login_url
  end

  def create
    authenticate!

    if logged_in?
      flash[:notice] = _("Login Successful")
      redirect_to(session.delete(:original_uri) || '/dashboard')
    end
  end

  def destroy
    logout
    flash[:notice] = _("Logout Successful")
    redirect_to new_login_url
  end

  def unauthenticated
    flash[:error] = _("You've entered an incorrect username or password combination, please try again.")
    redirect_to new_login_url
    false
  end
end

