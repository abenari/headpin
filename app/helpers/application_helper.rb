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

module ApplicationHelper

  def project_name
    _("Headpin")
  end
  
  def default_title
    _("Open Source Subscription Management")
  end  

  def two_panel(collection, options)
    options[:accessor] ||= "id"
    enable_create = options[:enable_create]
    enable_create = true if enable_create.nil?
    enable_sort = options[:enable_sort] ? options[:enable_sort] : false
    render :partial => "common/panel", 
           :locals => {
             :title => options[:title], 
             :name => options[:name], 
             :create => options[:create],
             :enable_create => enable_create,
             :enable_sort => enable_sort,
             :columns => options[:col],
             :custom_rows => options[:custom_rows],
             :collection => collection,
             :accessor=>options[:accessor],
             :url=>options[:url], 
             :ajax_scroll =>options[:ajax_scroll]}
  end

  def one_panel(panel_id, collection, options)
    options[:accessor] ||= "id"
    panel_id ||= "panel"

    render :partial => "common/one_panel",
           :locals => {
             :single_select => options[:single_select] || false,
             :hover_text_cb => options[:hover_text_cb],
             :panel_id => panel_id,
             :title => options[:title],
             :name => options[:name],
             :columns => options[:col],
             :custom_rows => options[:custom_rows],
             :collection => collection,
             :accessor=>options[:accessor] }
  end

  def include_common_i18n
    render :partial => "common/common_i18n"
  end

  def include_editable_i18n
    render :partial=> "common/edit_i18n"
  end
  
  def stats_line(stats, options ={})
    render :partial => "common/stats_line",
      :locals => {:stats => stats}
  end
  
  def to_value_list(stats)
    list = ""
    prepend = ""
    stats.each do |stat|
      list += prepend
      prepend = ","
      list += stat.value.to_s
    end
    list
  end
  
  def remove_link(link_text, controller)
    render :partial => "common/tupane_remove", 
      :locals => {
          :link_text => link_text,
          :controller => controller}    
  end
end
