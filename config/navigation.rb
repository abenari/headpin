# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|

  navigation.autogenerate_item_ids = false
  navigation.id_generator = Proc.new {|key| "kp-#{key}"}
  
  navigation.items do |top_level|
    
    top_level.item :organizations, _("Organizations"), {:controller => 'organizations'}, :class=>'organizations' do |orgs_sub|
      orgs_sub.item :subscriptions, _("Subscriptions"), (@organization.nil? || @organization.id.nil?) ? "" : subscriptions_organization_path(@organization.id)
      orgs_sub.item :systems, _("Systems"), (@organization.nil? || @organization.id.nil?) ? "" : systems_organization_path(@organization.key)
    end 

    top_level.item :systems, _("Systems"), {:controller => 'systems'}, :class=>'systems' do |systems_sub|
      systems_sub.item :show, _("Details"), @system.nil? ? "" : system_path(@system.uuid)
      systems_sub.item :subscriptions, _("Current Subscriptions"), @system.nil? ? "" : subscriptions_system_path(@system.uuid)
      systems_sub.item :subscriptions, _("Available Subscriptions"), @system.nil? ? "" : "/systems/#{@system.uuid}/available_subscriptions"
    end
    
    
  end 

end 
