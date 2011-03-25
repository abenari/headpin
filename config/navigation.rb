# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|

  navigation.autogenerate_item_ids = false
  navigation.id_generator = Proc.new {|key| "kp-#{key}"}
  
  navigation.items do |top_level|
    
    top_level.item :organizations, _("Organizations"), {:controller => 'organizations'}, :class=>'organizations' do |orgs_sub|
      #orgs_sub.item :sub_orgs,  _("Sub-Organizations"), '#', :class => 'disabled'
      orgs_sub.item :subscriptions, _("Subscriptions"), @organization.nil? ? "" : subscriptions_organization_path(@organization['key'])
      orgs_sub.item :systems, _("Systems"), @organization.nil? ? "" : systems_organization_path(@organization['key'])
      #orgs_sub.item :create, _("Create"), '#', :class => 'disabled'
    end #end operations

    top_level.item :systems, _("Systems"), {:controller => 'systems'}, :class=>'systems' do |systems_sub|
      #orgs_sub.item :sub_orgs,  _("Sub-Organizations"), '#', :class => 'disabled'
      systems_sub.item :subscriptions, _("Subscriptions"), @consumer.nil? ? "" : subscriptions_system_path(@consumer['uuid'])
      #orgs_sub.item :create, _("Create"), '#', :class => 'disabled'
    end #end operations
    
    
  end #end top_level

end #end navigation
