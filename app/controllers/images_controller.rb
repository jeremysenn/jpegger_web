class ImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_image, only: [:show, :edit, :update, :destroy]
#  load_and_authorize_resource

  # GET /images
  # GET /images.json
  def index
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find_by_capture_sequence_number(params[:id], current_user.company_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      # order matters here in that to have access to model attributes in uploader methods, they need to show up before the file param in this permitted_params list 
      params.require(:image).permit()
    end
end
