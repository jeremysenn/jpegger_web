class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_back fallback_location: root_url, alert: exception.message
  end 
    
  protected
  # Permit additional parameters for Devise user
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :email, :company_id, :role, :active, :customer_name, :temporary_password])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :company_id, :role, :active, :customer_name, 
        company_attributes: [:name]])
  end
  
  ### Image Table Field Descriptions ###
  def image_field_descriptions
    @image_field_descriptions ||= session[:image_field_descriptions].blank? ? nil : session[:image_field_descriptions]
  end
  helper_method :image_field_descriptions
  
  def image_capture_seq_nbr_field_description
    @image_capture_seq_nbr_field_description ||= image_field_descriptions.blank? ? nil : image_field_descriptions["capture_seq_nbr"]
  end
  helper_method :image_capture_seq_nbr_field_description
  
  def image_ticket_nbr_field_description
    @image_ticket_nbr_field_description ||= image_field_descriptions.blank? ? nil : image_field_descriptions["ticket_nbr"]
  end
  helper_method :image_ticket_nbr_field_description
  
  def image_event_code_field_description
    @image_event_code_field_description ||= image_field_descriptions.blank? ? nil : image_field_descriptions["event_code"]
  end
  helper_method :image_event_code_field_description
  
  def image_cust_name_field_description
    @image_cust_name_field_description ||= image_field_descriptions.blank? ? nil : image_field_descriptions["cust_name"]
  end
  helper_method :image_cust_name_field_description
  ### End Image Table Field Descriptions ###
  
  ### Shipment Table Field Descriptions ###
  def shipment_field_descriptions
    @shipment_field_descriptions ||= session[:shipment_field_descriptions]
  end
  helper_method :shipment_field_descriptions
  
  def shipment_capture_seq_nbr_field_description
    @shipment_capture_seq_nbr_field_description ||= shipment_field_descriptions["capture_seq_nbr"]
  end
  helper_method :shipment_capture_seq_nbr_field_description
  
  def shipment_ticket_nbr_field_description
    @shipment_ticket_nbr_field_description ||= shipment_field_descriptions["ticket_nbr"]
  end
  helper_method :shipment_ticket_nbr_field_description
  
  def shipment_event_code_field_description
    @shipment_event_code_field_description ||= shipment_field_descriptions["event_code"]
  end
  helper_method :shipment_event_code_field_description
  
  def shipment_cust_name_field_description
    @shipment_cust_name_field_description ||= shipment_field_descriptions["cust_name"]
  end
  helper_method :shipment_cust_name_field_description
  ### End Shipment Table Field Descriptions ###
  
  ### Searchable Tables ###
  def images_table
    @images_table ||= session[:images_table]
  end
  helper_method :images_table
  
  def shipments_table
    @shipments_table ||= session[:shipments_table]
  end
  helper_method :shipments_table
  ### End Searchable Tables ###
  
end
