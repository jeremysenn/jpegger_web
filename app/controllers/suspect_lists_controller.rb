class SuspectListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_suspect_list, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /suspect_lists
  # GET /suspect_lists.json
  def index
    @suspect_lists = SuspectList.all
  end

  # GET /suspect_lists/1
  # GET /suspect_lists/1.json
  def show
    require 'csv'
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
