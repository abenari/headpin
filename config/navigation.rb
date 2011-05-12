# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|

  navigation.autogenerate_item_ids = false
  navigation.id_generator = Proc.new {|key| "kp-#{key}"}
  
  navigation.items do |top_level|

    top_level.item :dashboard, _("Dashboard"), "/dashboard"
    
    top_level.item :subscriptions, _('Subscriptions'), subscriptions_path do |sub|
      sub.item :current, _('Current Subscriptions'), subscriptions_path
      sub.item :imports, _('Recent Imports'), imports_path
    end

    top_level.item :systems, _("Systems"), systems_path do |systems_sub|
         
      systems_sub.item :details, _("Details"), systems_path do |details_sub|
          if (not @system.nil?)
            details_sub.item :edit, ("General"),
              edit_system_path(@system.uuid), :class => 'navigation_element'
              
            details_sub.item :facts, ("Facts"),
              facts_system_path(@system.uuid), :class => 'navigation_element'              
              
            details_sub.item :subscriptions, _("Current Subscriptions"), 
              subscriptions_system_path(@system.uuid), :class => 'navigation_element'
              
            details_sub.item :avail_subscriptions, _("Available Subscriptions"), 
              "/systems/#{@system.uuid}/available_subscriptions", :class => 'navigation_element'
              
            details_sub.item :events, _("Events"), 
              "/systems/#{@system.uuid}/events", :class => 'navigation_element' 
          end
       end
    end

    # Hide this entire section if user is not an admin:
    top_level.item :administration, _("Admin"), "/admin", 
      :if => Proc.new { not @user.nil?  and @user.superAdmin? } do |admin_sub|

      admin_sub.item :organizations, _("Organizations"), 
        {:controller => 'admin/organizations'}, :class => 'organizations' 

    end 

    
    
  end 

end 
