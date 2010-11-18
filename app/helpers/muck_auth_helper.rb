module MuckAuthHelper
  
  # add code to help generate links like this:
  # /auth/twitter
  
  def auth_service_name(service)
    service.titleize
  end
  
end