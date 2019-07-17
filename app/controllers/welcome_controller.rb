class WelcomeController < ApplicationController
  before_action :set_image_field_descriptions, if: -> { current_user and not current_user.super? and FieldDescription.search_images_table?(current_user)}
  before_action :set_shipment_field_descriptions, if: -> { current_user and not current_user.super? and FieldDescription.search_shipments_table?(current_user)}
  before_action :set_searchable_tables, if: -> { current_user and not current_user.super? }
      
  def dashboard
    @image_file = ImageFile.find(flash[:image_file_id]) unless flash[:image_file_id].blank?
    @show_thumbnails = params[:show_thumbnails]
    unless current_user.blank? or current_user.super?
      unless params[:search].blank?
        @search_params = params[:search]
        @customer_name = params[:search][:customer_name]
        @event_code = params[:search][:event_code]
        @ticket_number = params[:search][:ticket_number]
        @start_date = params[:search][:start_date]
        @end_date = params[:search][:end_date]
        if @ticket_number.blank? and @customer_name.blank? and @event_code.blank? and (@start_date.blank? or @end_date.blank?)
          @all_images = []
          flash[:alert] = "Please enter a search criteria or date range."
          redirect_to root_path
        else
          if current_user.admin?
            @all_images = Image.search(params[:search], current_user).reverse
          elsif current_user.external?
            @all_images = Image.external_user_search(params[:search], current_user).reverse
          end
        end
      else
        @start_date = Date.today
        @end_date = Date.today
        if current_user.admin?
          @all_images = Image.find_all_by_date_range(@start_date, @end_date, current_user).reverse
        elsif current_user.external?
          @all_images = Image.external_user_find_all_by_date_range(@start_date, @end_date, current_user).reverse
        end
      end
      @images = Kaminari.paginate_array(@all_images).page(params[:page]).per(20)
#      @images = []
    end
  end
  
  private
  
  def set_image_field_descriptions
    if image_field_descriptions.blank?
      field_descriptions_hash = Hash.new
      FieldDescription.all_for_images_table(current_user).each do |f| 
        field_descriptions_hash[f['FIELDNAME']] = f["DISPLAYNAME"]
      end
      session[:image_field_descriptions] = field_descriptions_hash
    end
  end
  
  def set_shipment_field_descriptions
    if shipment_field_descriptions.blank?
      field_descriptions_hash = Hash.new
      FieldDescription.all_for_shipments_table(current_user).each do |f| 
        field_descriptions_hash[f['FIELDNAME']] = f["DISPLAYNAME"]
      end
      session[:shipment_field_descriptions] = field_descriptions_hash
    end
  end
  
  def set_searchable_tables
    if FieldDescription.search_images_table?(current_user)
      session[:images_table] = true
    end
    if FieldDescription.search_shipments_table?(current_user)
      session[:shipments_table] = true
    end
  end
  
end
