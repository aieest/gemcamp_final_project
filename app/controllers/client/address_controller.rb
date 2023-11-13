class Client::AddressController < ApplicationController
  before_action :authenticate_client_user!
  before_action :set_address, only: [:update, :destroy]
  before_action :get_default_address, only: [:update]

  def index
  end

  def new
    @address = current_client_user.addresses.build
  end

  def create
    @address = current_client_user.addresses.build(address_params)
    if @address.save
      flash[:notice] = "Added new address."
      redirect_to client_address_index_path
    else
      render :new
    end
  end

  def edit
    if @address.save
      flash[:notice] = "Added new address."
      redirect_to client_address_index_path
    else
      render :new
    end
  end

  def update
    if params[:commit] == 'Set as default'
      if @default_address.present?
        @default_address.is_default = false
        @default_address.save
      end

      @address.is_default = true
      if @address.save
        flash[:notice] = 'Changed default address.'
        redirect_to client_address_index_path
      end
    end
  end

  def destroy
    @address.destroy
    flash[:notice] = "Address deleted."
    redirect_to client_address_index_path
  end

  private

  def address_params
    params.require(:address).permit(:genre, :name, :street_address, :phone_number, :remark, :user_id, :region_id, :province_id, :city_id, :barangay_id)
  end

  def set_address
    @address = current_client_user.addresses.find(params[:id])
  end

  def get_default_address
    @default_address = current_client_user.addresses.default[0]
  end
end
