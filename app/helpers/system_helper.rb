module SystemHelper

  # Return a translated string for the system's entitlement validity:
  def entitlement_status(system)
    status = system.facts.attributes['system.entitlements_valid']
    return _("Unknown") if status.nil?
    return _("Valid") if status
    return _("Invalid")
  end

end
