class Client::Me::WinningsController < ApplicationController
  before_action :authenticate_client_user!
  before_action :set_winning, except: :index
  def index
    @winnings = current_client_user.winning_items.includes(:item, :ticket, address: [ :city, :barangay, :province ])
  end


  def edit_claim_prize
    @addresses = current_client_user.addresses.includes(:city, :barangay, :province, :region)
  end

  def edit_share_prize; end

  def update
    if params[:commit] && params[:commit] == 'Claim'
      @winning.state = 'claimed'
      if @winning.update(claiming_prize_params)
        flash[:notice] = 'Claimed item.'
        redirect_to client_winning_history_index_path
      else
        flash.now[:alert] = @winning.errors.full_messages
        render :edit_claim_prize
      end
    elsif params[:commit] && params[:commit] == 'Share'
      @winning.state = 'shared'
      if @winning.update(sharing_prize_params)
        flash[:notice] = 'Shared item.'
        redirect_to client_winning_history_index_path
      else
        flash.now[:alert] = @winning.errors.full_messages
        render :edit_share_prize
      end
    end
  end

  private

  def set_winning
    @winning = Winner.find(params[:id])
  end

  def claiming_prize_params
    params.require(:winner).permit(:address_id)
  end

  def sharing_prize_params
    params.require(:winner).permit(:picture, :comment)
  end
end
