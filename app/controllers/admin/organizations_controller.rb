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

class Admin::OrganizationsController < ApplicationController
  include AutoCompleteSearch
  navigation :organizations
  before_filter :require_user
  before_filter :require_admin
  respond_to :html, :js

  def section_id
    'admin'
  end
  
  def index
    @organizations = @visible_orgs
  end

  def use
    @organization = Organization.find(params[:workingorg])
    self.working_org = @organization
    flash[:notice] = N_("Now using organization '#{@organization.displayName}'.")
    redirect_to :back
  end

  def new
    @organization = Organization.new
    render :partial => 'new'
  end

  def create
    @organization = Organization.new(params[:organization])
    if @organization.save
      flash[:notice] = N_("Organization '#{@organization.displayName}' was created.")
      redirect_to :action => :index
    else
      errors _('There were errors creating the organization:'), @organization.errors.full_messages
      render :new
    end
  end

  def edit
    @organization = Organization.find(params[:id])
    render :partial => 'edit', :layout => "tupane_layout"    
  end

  def update
    @organization = Organization.find(params[:id])
    @organization.update_attributes(params[:organization])

    @organization.save!

    respond_to do |format|
      format.html {render :text => params[:organization].values.first}
      format.js
    end
  end

  def destroy
    @organization = Organization.find(params[:id])

    begin
      @organization.destroy
      flash[:notice] = N_("Organization '#{@organization.displayName}' was deleted.")
      redirect_to :action => 'index'
    rescue ActiveResource::ForbiddenAccess => error
      errors error.message
      render :show
    end
  end  

  def systems
    @organization = Organization.find(params[:id])
    self.working_org = @organization
    redirect_to systems_path
  end

  def subscriptions
    @organization = Organization.find(params[:id])
    self.working_org = @organization
    redirect_to subscriptions_path
  end
  
  def events
    @organization = Organization.find(params[:id])    
    @events = Event.find_by_org(@organization.key)
    render :partial => 'edit_events', :layout => "tupane_layout"   
  end  

end
