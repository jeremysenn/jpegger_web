class SearchesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  
  helper_method :searches_sort_column, :searches_sort_direction


  # GET /searches
  # GET /searches.json
  def index
    @searches = current_user.company.searches.order("#{searches_sort_column} #{searches_sort_direction}").page(params[:page]).per(20)
  end

  # GET /searches/1
  # GET /searches/1.json
  def show
    @image_event_codes = LookupDef.image_event_codes(current_user)
  end

  # GET /searches/new
  def new
    @search = Search.new
  end

  # GET /searches/1/edit
  def edit
  end

  # POST /searches
  # POST /searches.json
  def create
    @search = Search.new(search_params)
    respond_to do |format|
      if @search.save
#        format.html { redirect_to searches_path, notice: 'Search was successfully created.' }
        format.html { redirect_to @search, notice: 'Search was successfully created.' }
        format.json { render :show, status: :created, location: @search }
      else
        format.html { render :new }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /searches/1
  # PATCH/PUT /searches/1.json
  def update
    respond_to do |format|
      if @search.update(search_params)
#        format.html { redirect_to searches_path, notice: 'Search was successfully updated.' }
        format.html { redirect_to @search, notice: 'Search was successfully updated.' }
        format.json { render :show, status: :ok, location: @search }
      else
        format.html { render :edit }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /searches/1
  # DELETE /searches/1.json
  def destroy
    @search.destroy
    respond_to do |format|
      format.html { redirect_to searches_url, notice: 'Search was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search
      @search = Search.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_params
      params.require(:search).permit()
    end
    
    ### Secure the searches sort direction ###
    def searches_sort_direction
      %w[asc desc].include?(params[:searches_direction]) ?  params[:searches_direction] : "desc"
    end

    ### Secure the searches sort column name ###
    def searches_sort_column
      ["created_at", "user_id", "table_name", "event_code", "customer_name", "ticket_number", "start_date", "end_date"].include?(params[:searches_column]) ? params[:searches_column] : "created_at"
    end
    
end
