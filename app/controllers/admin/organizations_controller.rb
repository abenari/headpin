require 'pp'

class Admin::OrganizationsController < ApplicationController
  navigation :organizations
  before_filter :require_user
  before_filter :require_admin
  respond_to :html, :js

  def index
    @organizations = @visible_orgs
  end

  def use
    @organization = Organization.find(params[:workingorg])
    self.working_org = @organization
    flash[:notice] = N_("Now using organization '#{@organization.displayName}'.")
    #redirect_to session.delete(:original_uri) || admin_organization_path(@organization.key)
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
    render :partial => 'edit'
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

end
