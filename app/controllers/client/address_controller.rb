class Client::AddressController < ApplicationController
  before_action :authenticate_client_user!
  before_action :set_address, only: [:edit, :update, :destroy]

  def index
  end

  def new
    @address = current_client_user.addresses.build
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def address_params
  end

  def set_address
    @address = current_client_user.addresses.find(params[:id])
  end
end
