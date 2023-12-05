class Client::OrdersController < ApplicationController
  before_action :authenticate_client_user!
  before_action :set_offer

  def create
    @order = current_client_user.orders.build do |order|
      order.offer = @offer
      order.genre = 'deposit'
      order.amount = @offer.amount
      order.coin = @offer.coin
    end

    if @order.save
      flash[:notice] = 'Created order.'
      redirect_to client_shop_index_path
    else
      flash.now[:alert] = @order.errors.full_message
      render shop_path(@offer)
    end
  end

  private

  def set_offer
    @offer = Offer.find(params[:offer])
    unless @offer
      flash[:alert] = 'Invalid request.'
      redirect_to client_shop_index_path
    end
  end
end

