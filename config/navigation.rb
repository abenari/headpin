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

    top_level.item :systems, _("Systems"), systems_path, 
      :class=>'systems' do |systems_sub|

      systems_sub.item :show, _("Details"), @system, 
        :if => Proc.new { not @system.nil? }

      systems_sub.item :subscriptions, _("Current Subscriptions"), 
        @system.nil? ? "" : subscriptions_system_path(@system.uuid), 
        :if => Proc.new { not @system.nil? }
      
      systems_sub.item :subscriptions, _("Available Subscriptions"), 
        @system.nil? ? "" : "/systems/#{@system.uuid}/available_subscriptions", 
        :if => Proc.new { not @system.nil? }

    end

    # Hide this entire section if user is not an admin:
    top_level.item :administration, _("Admin"), "/admin", 
      :if => Proc.new { not @user.nil?  and @user.superAdmin? } do |admin_sub|

      admin_sub.item :organizations, _("Organizations"), 
        {:controller => 'admin/organizations'}, :class => 'organizations' 

    end 

    
    
  end 

end 
