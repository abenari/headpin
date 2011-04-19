module ApplicationHelper

  def two_panel(collection, options)
    options[:accessor] ||= "id"
    render :partial => "common/panel",
           :locals => {
             :title => options[:title],
             :name => options[:name],
             :create => options[:create],
             :columns => options[:col],
             :collection => collection,
             :accessor=>options[:accessor] }
  end

end
