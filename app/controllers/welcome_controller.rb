class WelcomeController < ApplicationController
  
  def dashboard
    if current_user and current_user.admin?
      unless params[:search].blank?
        @customer_name = params[:search][:customer_name]
        @event_code = params[:search][:event_code]
        @ticket_number = params[:search][:ticket_number]
        @start_date = params[:search][:start_date] ||= Date.today.last_week
        @end_date = params[:search][:end_date] ||= Date.today
        @all_images = Image.search(params[:search], current_user.company_id).reverse
      else
        @start_date = Date.today.last_week
        @end_date = Date.today
        @all_images = Image.find_all_by_date_range(@start_date, @end_date, current_user.company_id).reverse
      end
      @images = Kaminari.paginate_array(@all_images).page(params[:page]).per(10)
#      @images = []
    end
  end
  
end
