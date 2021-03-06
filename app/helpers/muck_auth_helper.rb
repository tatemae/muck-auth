module MuckAuthHelper
    
  def auth_list(include_icons, services_to_exclude = nil)
    auth_list_html(remaining_services(services_to_exclude), include_icons)
  end
  
  def remaining_services(services_to_exclude = nil)
    services = Secrets.auth_credentials.keys
    services = services - services_to_exclude.map(&:provider) if services_to_exclude
    services
  end
  
  def signin_services(services_to_exclude = nil)
    services = Secrets.auth_credentials    
    services = services.keys.find_all{|key| services[key]['valid_signin']}
    services = services - services_to_exclude.map(&:provider) if services_to_exclude
    services
  end
  
  def signin_list(include_icons, services_to_exclude = nil)
    auth_list_html(signin_services(services_to_exclude), include_icons)
  end
  
  def auth_list_html(services, include_icons = true)
    list = ''
    services.each do |auth|
      list << %Q{<li class="#{auth_css_class(auth)} auth_service service-link" #{auth_icon_back(auth, include_icons)} title="#{auth_title(auth)}">#{auth_link(auth)}</li>}
    end
    list.html_safe
  end
  
  def auth_icon_back(auth, include_icons = true)
    if include_icons
      icon = service_icon_background(auth)
    else
      icon = ''
    end
  end
  
  def auth_link(auth)
    link_to(auth.titleize, "/auth/#{auth}")
  end
  
  def auth_name(auth)
    auth.titleize
  end
  
  def auth_title(auth)
    translate('muck.auth.connect_to_account_title', :service => auth.to_s.humanize)
  end
  
  def auth_css_class(auth)
    auth.parameterize
  end
  
end