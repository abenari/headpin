module ApplicationHelper

  def product_name
    _("Headpin")
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
             :accessor=>options[:accessor] }
  end

end
