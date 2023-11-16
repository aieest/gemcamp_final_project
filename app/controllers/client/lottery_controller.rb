class Client::LotteryController < ApplicationController
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

  def skip_authentication

    unless user_client_signed_in?
      return
    end

    redirect_to root_path, notice: 'You are already signed in.'
  end
end
