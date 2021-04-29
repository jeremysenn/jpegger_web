class ShipmentsController < ApplicationController
#  before_action :set_shipment_field_descriptions, if: -> { current_user and not current_user.super? and FieldDescription.search_shipments_table?(current_user)}
  before_action :authenticate_user!
  before_action :set_shipment, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource only: [:index]

  # GET /shipments
  # GET /shipments.json
  def index
    @ticket_number = params[:ticket_number]
    @yard_id = params[:yardid]
    @customer_name = params[:customer_name]
    @event_code = params[:event_code]
    @start_date = params[:start_date].blank? ? Date.today.last_week.to_s : params[:start_date]
    @end_date = params[:end_date].blank? ? Date.today.to_s : params[:end_date]
    @shipments = Shipment.find(:all, :params => { ticket_nbr: @ticket_number, yardid: @yard_id, cust_name: @customer_name,
        event_code: @event_code, start_date:  @start_date, end_date:  @end_date, limit: 100})
    @show_thumbnails = params[:show_thumbnails]
    @shipment_file = ShipmentFile.find(flash[:shipment_file_id]) unless flash[:shipment_file_id].blank?
    
    
#    @shipment_file = ShipmentFile.find(flash[:shipment_file_id]) unless flash[:shipment_file_id].blank?
#    @show_thumbnails = params[:show_thumbnails]
#    unless current_user.blank?
#      unless params[:search].blank?
#        @customer_name = params[:search][:customer_name]
#        @event_code = params[:search][:event_code]
#        @ticket_number = params[:search][:ticket_number]
#        @start_date = params[:search][:start_date]
#        @end_date = params[:search][:end_date]
#        if current_user.admin?
#          @all_shipments = Shipment.search(params[:search], current_user).reverse
#        elsif current_user.external?
#          @all_shipments = Shipment.external_user_search(params[:search], current_user).reverse
#        end
#        SaveSearchWorker.perform_async(current_user.id, 'shipments', @event_code, @customer_name, @ticket_number, @start_date, @end_date)
#      else
#        @start_date = Date.today
#        @end_date = Date.today
#        if current_user.admin?
#          @all_shipments = Shipment.find_all_by_date_range(@start_date, @end_date, current_user).reverse
#        elsif current_user.external?
#          @all_shipments = Shipment.external_user_find_all_by_date_range(@start_date, @end_date, current_user).reverse
#        end
#      end
#      @shipments = Kaminari.paginate_array(@all_shipments).page(params[:page]).per(12)
#    end
#    flash[:shipment_file_id] = nil
  end

  # GET /shipment/1
  # GET /shipment/1.json
  def show
  end

  # GET /shipments/new
  def new
  end

  # GET /shipments/1/edit
  def edit
  end

  # DELETE /shipments/1
  # DELETE /shipments/1.json
  def destroy
    @shipment.destroy
    respond_to do |format|
      format.html { redirect_to shipment_files_url, notice: 'Shipment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def show_jpeg_shipment
    blob = Shipment.jpeg_shipment(params[:id], current_user.company_id)
    unless blob[0..3] == "%PDF" 
      send_data blob, :type => 'shipment/jpeg',:disposition => 'inline'
    else
      # PDF file
      send_data blob, :type => 'application/pdf',:disposition => 'inline'
    end
  end
  
  def show_preview_shipment
    send_data Shipment.preview(params[:id], current_user.company_id), :type => 'shipment/jpeg',:disposition => 'inline'
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_shipment
#    @shipment = Shipment.find_by_capture_sequence_number(params[:id], current_user)
    @shipment = Shipment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def shipment_params
    # order matters here in that to have access to model attributes in uploader methods, they need to show up before the file param in this permitted_params list 
    params.require(:shipment).permit()
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
  
end
