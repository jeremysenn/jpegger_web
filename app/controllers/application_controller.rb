class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_back fallback_location: root_url, alert: exception.message
  end 
    
  protected
  # Permit additional parameters for Devise user
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :email, :company_id, :role, :active, :customer_name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :company_id, :role, :active, :customer_name])
  end
  
end
