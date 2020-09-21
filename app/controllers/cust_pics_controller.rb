class CustPicsController < ApplicationController
#  before_action :set_cust_pic_field_descriptions, if: -> { current_user and not current_user.super? and FieldDescription.search_cust_pics_table?(current_user)}
  before_action :authenticate_user!
  before_action :set_cust_pic, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource only: [:index]

  # GET /cust_pics
  # GET /cust_pics.json
  def index
    @customer_number = params[:customer_number]
    @yard_id = params[:yardid]
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @event_code = params[:event_code]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @cust_pics = CustPic.find(:all, :params => { cust_nbr: @customer_number, yardid: @yard_id, first_name: @first_name, last_name: @last_name,
        event_code: @event_code, start_date:  @start_date, end_date:  @end_date, limit: 100})
    @show_thumbnails = params[:show_thumbnails]
    @cust_pic_file = CustPicFile.find(flash[:cust_pic_file_id]) unless flash[:cust_pic_file_id].blank?
    
    
#    @cust_pic_file = CustPicFile.find(flash[:cust_pic_file_id]) unless flash[:cust_pic_file_id].blank?
#    @show_thumbnails = params[:show_thumbnails]
#    unless current_user.blank?
#      unless params[:search].blank?
#        @customer_name = params[:search][:customer_name]
#        @event_code = params[:search][:event_code]
#        @ticket_number = params[:search][:ticket_number]
#        @start_date = params[:search][:start_date]
#        @end_date = params[:search][:end_date]
#        if current_user.admin?
#          @all_cust_pics = CustPic.search(params[:search], current_user).reverse
#        elsif current_user.external?
#          @all_cust_pics = CustPic.external_user_search(params[:search], current_user).reverse
#        end
#        SaveSearchWorker.perform_async(current_user.id, 'cust_pics', @event_code, @customer_name, @ticket_number, @start_date, @end_date)
#      else
#        @start_date = Date.today
#        @end_date = Date.today
#        if current_user.admin?
#          @all_cust_pics = CustPic.find_all_by_date_range(@start_date, @end_date, current_user).reverse
#        elsif current_user.external?
#          @all_cust_pics = CustPic.external_user_find_all_by_date_range(@start_date, @end_date, current_user).reverse
#        end
#      end
#      @cust_pics = Kaminari.paginate_array(@all_cust_pics).page(params[:page]).per(12)
#    end
#    flash[:cust_pic_file_id] = nil
  end

  # GET /cust_pic/1
  # GET /cust_pic/1.json
  def show
  end

  # GET /cust_pics/new
  def new
  end

  # GET /cust_pics/1/edit
  def edit
  end

  # DELETE /cust_pics/1
  # DELETE /cust_pics/1.json
  def destroy
    @cust_pic.destroy
    respond_to do |format|
      format.html { redirect_to cust_pic_files_url, notice: 'CustPic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def show_jpeg_cust_pic
    blob = CustPic.jpeg_cust_pic(params[:id], current_user.company_id)
    unless blob[0..3] == "%PDF" 
      send_data blob, :type => 'cust_pic/jpeg',:disposition => 'inline'
    else
      # PDF file
      send_data blob, :type => 'application/pdf',:disposition => 'inline'
    end
  end
  
  def show_preview_cust_pic
    send_data CustPic.preview(params[:id], current_user.company_id), :type => 'cust_pic/jpeg',:disposition => 'inline'
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_cust_pic
    @cust_pic = CustPic.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cust_pic_params
    # order matters here in that to have access to model attributes in uploader methods, they need to show up before the file param in this permitted_params list 
    params.require(:cust_pic).permit()
  end

  def set_cust_pic_field_descriptions
    if cust_pic_field_descriptions.blank?
      field_descriptions_hash = Hash.new
      FieldDescription.all_for_cust_pics_table(current_user).each do |f| 
        field_descriptions_hash[f['FIELDNAME']] = f["DISPLAYNAME"]
      end
      session[:cust_pic_field_descriptions] = field_descriptions_hash
    end
  end
  
end
