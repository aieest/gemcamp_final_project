class Client::Me::WinningsController < ApplicationController
  before_action :authenticate_client_user!
  before_action :set_winning, except: :index
  def index
    @winnings = current_client_user.winning_items.includes(:item, :ticket, address: [ :city, :barangay, :province ])
  end


  def edit
    @addresses = current_client_user.addresses.includes(:city, :barangay, :province, :region)
  end

  def update
    @winning.state = 'claimed'
    if @winning.update(winning_params)
      flash[:notice] = 'Claimed item.'
      redirect_to client_winning_history_index_path
    else
      flash.now[:alert] = @winning.errors.full_messages
      render :edit
    end
  end

  private

  def set_winning
    @winning = Winner.find(params[:id])
  end

  def winning_params
    params.require(:winner).permit(:address_id)
  end
end
