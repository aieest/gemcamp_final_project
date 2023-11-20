class Client::LotteryController < ApplicationController
  # before_action :skip_authentication, only: [:lottery, :show]
  before_action :set_item, only: :show

  def index
    @user = current_client_user
    @categories = Category.all
    @selected_category = params[:category_id] ? Category.find(params[:category_id]) : nil
    @items = @selected_category ? @selected_category.items : Item.includes(:categories).all
    @items = @items.where("online_at < ? AND offline_at > ?", Time.current, Time.current).active.starting

    respond_to do |format|
      format.html
      format.js # Assuming you want to handle the asynchronous filtering
    end
  end

  def show
    # @user = current_client_user
    @progress = 25
    @user_tickets = Ticket.where(user: current_client_user, item: @item, batch_count: @item.batch_count)
  end

  private

  def skip_authentication

    unless client_user_signed_in?
      return
    end

    redirect_to client_lottery_index_path, notice: 'You are already signed in.'
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
