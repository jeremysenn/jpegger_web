class UsersController < ApplicationController
  before_action :authenticate_user!, except: :forgot_password
  before_action :set_user, only: [:show, :edit, :update, :destroy, :pin_verification, :verify_phone, :confirm]
  load_and_authorize_resource
  helper_method :users_sort_column, :users_sort_direction


  # GET /users
  # GET /users.json
  def index
    unless params[:role].blank?
      @role = params[:role]
    else
      @role = ['admin', 'basic', 'external']
    end
    @users = current_user.company.users.where(role: @role).order("#{users_sort_column} #{users_sort_direction}")
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    temporary_password = SecureRandom.random_number(10**6).to_s
    @user.temporary_password = temporary_password
    @user.password = temporary_password
    @user.password_confirmation = temporary_password
    respond_to do |format|
      if @user.save
#          format.html { redirect_to users_admin_path(@user), notice: 'User was successfully created.' }
        format.html { redirect_to users_admin_index_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_admin_index_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def forgot_password
    @user = User.find_by(phone: params[:phone])
    unless @user.blank?
#      @user.send_reset_password_instructions
      @user.send_reset_password_instructions_text_message
    end
    redirect_to new_user_session_path, notice: 'Forgot password link sent.'
  end
  
  def confirm
    @user.confirmed_at = Time.now
    if @user.save
      redirect_back fallback_location: root_path, notice: 'Web user successfully confirmed.'
    else
      redirect_back fallback_location: root_path, notice: 'There was a problem trying to confirm the web user.'
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :company_id, :email, :password, :active, :role, :customer_name, :images, :shipments)
    end
    
    ### Secure the users sort direction ###
    def users_sort_direction
      %w[asc desc].include?(params[:users_direction]) ?  params[:users_direction] : "asc"
    end

    ### Secure the users sort column name ###
    def users_sort_column
      ["email", "first_name", "last_name", "role", "customer_name", "active", "sign_in_count", "current_sign_in_at", 
        "last_sign_in_at", "current_sign_in_ip", "last_sign_in_ip"].include?(params[:users_column]) ? params[:users_column] : "first_name"
    end
    
end