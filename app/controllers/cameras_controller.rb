class CamerasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_camera, only: [:show, :edit, :update, :destroy, :capture_image]
  load_and_authorize_resource
  helper_method :cameras_sort_column, :cameras_sort_direction


  # GET /cameras
  # GET /cameras.json
  def index
    @cameras = Camera.all
  end

  # GET /cameras/1
  # GET /cameras/1.json
  def show
  end

  # GET /cameras/new
  def new
    @camera = Camera.new
  end

  # GET /cameras/1/edit
  def edit
  end

  # POST /cameras
  # POST /cameras.json
  def create
    @camera = Camera.new(camera_params)
    respond_to do |format|
      if @camera.save
        format.html { redirect_to cameras_path(@camera), notice: 'Camera was successfully created.' }
        format.json { render :show, status: :created, location: @camera }
      else
        format.html { render :new }
        format.json { render json: @camera.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cameras/1
  # PATCH/PUT /cameras/1.json
  def update
    respond_to do |format|
#      if @camera.update(camera_params)
      if @camera.update_attributes(camera_params)
        format.html { redirect_to cameras_path, notice: 'Camera was successfully updated.' }
        format.json { render :show, status: :ok, location: @camera }
      else
        format.html { render :edit }
        format.json { render json: @camera.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cameras/1
  # DELETE /cameras/1.json
  def destroy
    @camera.destroy
    respond_to do |format|
      format.html { redirect_to cameras_url, notice: 'Camera was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  # GET /cameras/1/capture_image
  def capture_image
    image = @camera.get(:capture_image, ticket_nbr: params[:ticket_nbr], yardid: params[:yardid], camera_group: params[:camera_group])
    unless image.blank? or image['capture_seq_nbr'].blank?
      redirect_to image_path(image['capture_seq_nbr']), notice: "Camera image capture successful."
    else
      redirect_back fallback_location: cameras_path, alert: 'There was a problem with the camera image capture.'
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_camera
      @camera = Camera.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def camera_params
      params.require(:camera).permit(:camera_name, :device_name, :ip_address, :port_nbr)
    end
    
    ### Secure the cameras sort direction ###
    def cameras_sort_direction
      %w[asc desc].include?(params[:cameras_direction]) ?  params[:cameras_direction] : "asc"
    end

    ### Secure the cameras sort column name ###
    def cameras_sort_column
      ["camera_name", "yardid"].include?(params[:cameras_column]) ? params[:cameras_column] : "camera_name"
    end
    
end
