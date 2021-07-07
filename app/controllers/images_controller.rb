class ImagesController < ApplicationController
#  before_action :set_image_field_descriptions, if: -> { current_user and not current_user.super? and FieldDescription.search_images_table?(current_user)}
  before_action :authenticate_user!, except: :index
  before_action :set_image, only: [:show, :edit, :update, :destroy]
#  load_and_authorize_resource only: [:index]

  # GET /images
  # GET /images.json
  def index
#    @images = Image.all
    if current_user.blank? and params[:token].blank?
      flash[:error] = "You must login before accessing that page."
      redirect_to new_user_session_path
    elsif current_user.blank? and not params[:token].blank?
      decrypted_token = Decrypt.base64_decode_decrypt(params[:token])
      Rails.logger.debug "*********** decrypted_token: #{decrypted_token}"
      unless decrypted_token.blank?
        token_date_time = decrypted_token.to_datetime
        if Time.now < token_date_time
          @ticket_number = params[:ticket_number]
          @yard_id = params[:yardid]
          @customer_name = params[:customer_name]
          @event_code = params[:event_code]
          @start_date = params[:start_date].blank? ? Date.today.last_week.to_s : params[:start_date]
          @end_date = params[:end_date].blank? ? Date.today.to_s : params[:end_date]
          @images = Image.find(:all, :params => { ticket_nbr: @ticket_number, yardid: @yard_id, cust_name: @customer_name,
              event_code: @event_code, start_date:  @start_date, end_date:  @end_date, limit: 100})
          @show_thumbnails = params[:show_thumbnails]
          @image_file = ImageFile.find(flash[:image_file_id]) unless flash[:image_file_id].blank?
        else
          flash[:error] = "Token has expired."
          redirect_to new_user_session_path
        end
      else
        flash[:error] = "Invalid token."
        redirect_to new_user_session_path
      end
    else
      authorize! :index, :images
      @ticket_number = params[:ticket_number]
      @yard_id = params[:yardid]
      @customer_name = params[:customer_name]
      @event_code = params[:event_code]
      @start_date = params[:start_date].blank? ? Date.today.last_week.to_s : params[:start_date]
      @end_date = params[:end_date].blank? ? Date.today.to_s : params[:end_date]
      @images = Image.find(:all, :params => { ticket_nbr: @ticket_number, yardid: @yard_id, cust_name: @customer_name,
          event_code: @event_code, start_date:  @start_date, end_date:  @end_date, limit: 100})
      @show_thumbnails = params[:show_thumbnails]
      @image_file = ImageFile.find(flash[:image_file_id]) unless flash[:image_file_id].blank?
    end
    
#    unless current_user.blank?
#      unless params[:search].blank?
#        @customer_name = params[:search][:customer_name]
#        @event_code = params[:search][:event_code]
#        @ticket_number = params[:search][:ticket_number]
#        @start_date = params[:search][:start_date]
#        @end_date = params[:search][:end_date]
#        if current_user.admin?
#          @all_images = Image.search(params[:search], current_user).reverse
#        elsif current_user.external?
#          @all_images = Image.external_user_search(params[:search], current_user).reverse
#        end
#        SaveSearchWorker.perform_async(current_user.id, 'images', @event_code, @customer_name, @ticket_number, @start_date, @end_date)
##        Search.create(user_id: current_user.id, table_name: 'images', event_code: @event_code, customer_name: @customer_name, ticket_number: @ticket_number, start_date: @start_date, end_date: @end_date)
#      else
#        @start_date = Date.today
#        @end_date = Date.today
#        if current_user.admin?
#          @all_images = Image.find_all_by_date_range(@start_date, @end_date, current_user).reverse
#        elsif current_user.external?
#          @all_images = Image.external_user_find_all_by_date_range(@start_date, @end_date, current_user).reverse
#        end
#      end
#      @images = Kaminari.paginate_array(@all_images).page(params[:page]).per(12)
#    end
#    flash[:image_file_id] = nil
  end

  # GET /image/1
  # GET /image/1.json
  def show
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end
  
  # POST /images
  # POST /images.json
  def create
    @image = Image.new(image_params)
    respond_to do |format|
      if @image.save
        format.html { redirect_to image_path(@image.capture_seq_nbr), notice: 'Image was successfully created.' }
        format.json { render :show, status: :created, location: @image }
      else
#        format.html { render :new }
        format.html { redirect_back fallback_location: images_path, alert: "There was a problem creating the image: #{@image.errors.full_messages}"}
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to image_files_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
  
  def set_image
#    @image = Image.find_by_capture_sequence_number(params[:id], current_user)
    @image = Image.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def image_params
    # order matters here in that to have access to model attributes in uploader methods, they need to show up before the file param in this permitted_params list 
    params.require(:image).permit(:ticket_nbr, :event_code, :yardid, :cust_name, :leadsonline, :file)
  end

  def set_image_field_descriptions
    if image_field_descriptions.blank?
      field_descriptions_hash = Hash.new
      FieldDescription.all_for_images_table(current_user).each do |f| 
        field_descriptions_hash[f['FIELDNAME']] = f["DISPLAYNAME"]
      end
      session[:image_field_descriptions] = field_descriptions_hash
    end
  end
  
end
