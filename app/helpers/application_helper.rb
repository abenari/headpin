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
    
    render :partial => "common/panel", 
           :locals => {
             :title => options[:title], 
             :name => options[:name], 
             :create => options[:create],
             :enable_create => enable_create,
             :columns => options[:col],
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
             :collection => collection,
             :accessor=>options[:accessor] }
  end

  def include_common_i18n
    render :partial => "common/common_i18n"
  end

  def include_editable_i18n
    render :partial=> "common/edit_i18n"
  end
end
