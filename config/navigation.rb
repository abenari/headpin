# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|

  navigation.autogenerate_item_ids = false
  navigation.id_generator = Proc.new {|key| "kp-#{key}"}
  
  navigation.items do |top_level|

    top_level.item :dashboard, _("Dashboard"), {:controller => 'dashboard'}

    top_level.item :subscriptions, _('Subscriptions'), {:controller => :subscriptions}
    
    top_level.item :systems, _("Systems"), {:controller => 'systems'}, 
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
    
    
  end 

end 
