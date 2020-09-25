class SuspectListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_suspect_list, only: [:show, :edit, :update, :destroy, :images_download]
  load_and_authorize_resource
  include ActionController::Live # required for streaming
  include ZipTricks::RailsStreaming
    

  # GET /suspect_lists
  # GET /suspect_lists.json
  def index
    @suspect_lists = SuspectList.all
  end

  # GET /suspect_lists/1
  # GET /suspect_lists/1.json
  def show
    require 'csv'
    unless @suspect_list.file.blank? or @suspect_list.file.path.blank?
      @headers = @suspect_list.csv_file_headers
      csv_table = @suspect_list.csv_file_table
      @number_of_table_rows = csv_table.count unless csv_table.blank?
      @csv_table = Kaminari.paginate_array(csv_table).page(params[:page]).per(10)
    end
  end

  # GET /suspect_lists/new
  def new
    @suspect_list = SuspectList.new
  end

  # GET /suspect_lists/1/edit
  def edit
  end

  # POST /suspect_lists
  # POST /suspect_lists.json
  def create
    @suspect_list = SuspectList.new(suspect_list_params)

    respond_to do |format|
      if @suspect_list.save
        format.html { redirect_to @suspect_list, notice: 'Suspect list was successfully created.' }
        format.json { render :show, status: :created, location: @suspect_list }
      else
        format.html { render :new }
        format.json { render json: @suspect_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /suspect_lists/1
  # PATCH/PUT /suspect_lists/1.json
  def update
    respond_to do |format|
      if @suspect_list.update(suspect_list_params)
        format.html { redirect_to @suspect_list, notice: 'Suspect list was successfully updated.' }
        format.json { render :show, status: :ok, location: @suspect_list }
      else
        format.html { render :edit }
        format.json { render json: @suspect_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /suspect_lists/1
  # DELETE /suspect_lists/1.json
  def destroy
    @suspect_list.destroy
    respond_to do |format|
      format.html { redirect_to suspect_lists_url, notice: 'Suspect list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  # POST /suspect_lists/1/images_download
  def images_download
    zipname = "Suspect_List_#{@suspect_list.name}_#{@suspect_list.id}.zip"
    disposition = "attachment; filename=\"#{zipname}\""
    response.headers["Content-Disposition"] = disposition
    response.headers["Content-Type"] = "application/zip"
    response.headers["Last-Modified"] = Time.now.httpdate.to_s
    response.headers["X-Accel-Buffering"] = "no"
    
    writer = ZipTricks::BlockWrite.new do |chunk| 
      response.stream.write(chunk)
    end
    
    ZipTricks::Streamer.open(writer, auto_rename_duplicate_filenames: true) do |zip|
      @suspect_list.csv_file_table.uniq.each do |row|
        ticket_number = row.first[1]
        images = Image.find(:all, :params => { ticket_nbr: ticket_number})
        images.each do |image|
          file_name = "/ticket_#{ticket_number}/ticket_#{ticket_number}_id_#{image.capture_seq_nbr}.jpg"
          zip.write_deflated_file(file_name) do |file_writer|
#            file = Down.download(image.url)
            file = Down.download("#{request.protocol}#{request.host}#{image.url}", :verify_mode  => OpenSSL::SSL::VERIFY_NONE)
            file_writer << file.read
          end
        end
      end
    end
  ensure
    response.stream.close
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_suspect_list
      @suspect_list = SuspectList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def suspect_list_params
      params.require(:suspect_list).permit(:name, :file, :delimiter, :user_id, :company_id)
    end
end
