class SignaturesController < ApplicationController
  before_action :authenticate_user!
#  load_and_authorize_resource

  def new
#    @signature = current_user.build_signature
  end

  def create
    @signature = current_user.build_signature(signature_params)
    @signature.signed_on = DateTime.now
    if @signature.save
      redirect_to root_url, notice: 'Terms and Conditions accepted.'
    else
      render :new
    end
  end

  private

    def signature_params
      params.require(:signature).permit(:signature)
    end
end