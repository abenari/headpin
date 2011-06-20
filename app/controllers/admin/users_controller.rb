require 'pp'

class Admin::UsersController < ApplicationController
  include AutoCompleteSearch
  navigation :users
  before_filter :require_user
  before_filter :require_admin
  respond_to :html, :js

  def index
    @users = User.find(:all)
  end

  def new
    @user = User.new
    render :partial => 'new'
  end

  def create
    @user = User.new(params[:user])
    
    if @user.save
      flash[:notice] = N_("User '#{@user.username}' was created.")
      redirect_to :action => :index
    else
      errors _('There were errors creating the user:'), @user.errors.full_messages
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    render :partial => 'edit'
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])

    @user.save!

    respond_to do |format|
      format.html {render :text => params[:user].values.first}
      format.js
    end
  end

  def destroy
    @user = User.find(params[:id])

    begin
      @user.destroy
      flash[:notice] = N_("User '#{@user.username}' was deleted.")
      redirect_to :action => 'index'
    rescue ActiveResource::ForbiddenAccess => error
      errors error.message
      render :show
    end
  end  

end
