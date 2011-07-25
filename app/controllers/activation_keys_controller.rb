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

class ActivationKeysController < ApplicationController
  include AutoCompleteSearch
  respond_to :html, :js
    
  navigation :systems
  before_filter :require_user
  before_filter :require_org
  before_filter :find_activation_key, :only => [:edit, :update, :destroy] 
    
  def section_id
    'admin'
  end

  def new
    render :partial=>"new"
  end
  
  def index
    @activation_keys = ActivationKey.find_by_org(working_org.key)
  end
  
  def edit
    puts @activation_key.to_json()    
    render :partial => 'edit', :layout => "tupane_layout"  
  end   
  
  def update
    @activation_key.update_attributes(params[:activation_key])
    puts @activation_key.to_json()
    @activation_key.save!

    respond_to do |format|
      format.html {render :text => params[:activation_key].values.first}
      format.js
    end
  end    
  
  def create
    begin
      @activation_key = ActivationKey.new(:name => params[:name])
      @activation_key.owner= working_org
      @activation_key.save!
    rescue Exception => error
      errors error.to_s
      Rails.logger.info error.backtrace.join("\n")
      render :text=> error.to_s, :status=>:bad_request and return
    end
    render :partial=>"common/list_item", :locals=>{:item=>@activation_key, :accessor=>"id", :columns=>['name', 'poolCount']}
  end  
  
  def destroy
    begin
      @activation_key.destroy
      flash[:notice] = N_("Activation Key '#{@activation_key.name}' was deleted.")
      redirect_to :action => 'index'
    rescue ActiveResource::ForbiddenAccess => error
      errors error.message
      render :show
    end
  end    

  def find_activation_key
    @activation_key = ActivationKey.find(params[:id])
    @organization = Organization.find @activation_key.owner.key
  end
end
