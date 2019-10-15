class ImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_image, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource only: [:index]

  # GET /images
  # GET /images.json
  def index
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
        Search.create(user_id: current_user.id, table_name: 'images', event_code: @event_code, customer_name: @customer_name, ticket_number: @ticket_number, start_date: @start_date, end_date: @end_date)
      else
        @start_date = Date.today
        @end_date = Date.today
        if current_user.admin?
          @all_images = Image.find_all_by_date_range(@start_date, @end_date, current_user).reverse
        elsif current_user.external?
          @all_images = Image.external_user_find_all_by_date_range(@start_date, @end_date, current_user).reverse
        end
      end
      @images = Kaminari.paginate_array(@all_images).page(params[:page]).per(12)
    end
    flash[:image_file_id] = nil
  end

  # GET /image/1
  # GET /image/1.json
  def show
  end

  # GET /images/new
  def new
  end

  # GET /images/1/edit
  def edit
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
  
  def show_jpeg_image
    blob = Image.jpeg_image(params[:id], current_user.company_id)
    unless blob[0..3] == "%PDF" 
      send_data blob, :type => 'image/jpeg',:disposition => 'inline'
    else
      # PDF file
      send_data blob, :type => 'application/pdf',:disposition => 'inline'
    end
  end
  
  def show_preview_image
    send_data Image.preview(params[:id], current_user.company_id), :type => 'image/jpeg',:disposition => 'inline'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find_by_capture_sequence_number(params[:id], current_user)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      # order matters here in that to have access to model attributes in uploader methods, they need to show up before the file param in this permitted_params list 
      params.require(:image).permit()
    end
end
