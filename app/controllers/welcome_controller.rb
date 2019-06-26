class WelcomeController < ApplicationController
  
  def dashboard
    @image_file = ImageFile.find(flash[:image_file_id]) unless flash[:image_file_id].blank?
    unless current_user.blank?
      unless params[:search].blank?
        @customer_name = params[:search][:customer_name]
        @event_code = params[:search][:event_code]
        @ticket_number = params[:search][:ticket_number]
        @start_date = params[:search][:start_date]
        @end_date = params[:search][:end_date]
        if current_user.admin?
          @all_images = Image.search(params[:search], current_user).reverse
        elsif current_user.external?
          @all_images = Image.external_user_search(params[:search], current_user).reverse
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
  
end
