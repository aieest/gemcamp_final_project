class Admin::OrdersController < ApplicationController
  def index
    @orders = Order.all.includes(:user, :offer)
    @states = Order.aasm.states.map(&:name)
    @genres = Order.genres.keys
    @offers = Offer.all

    if params[:search].present?
      @orders = @orders.joins(:user).where("serial_number LIKE :search OR users.email LIKE :search", search: "%#{params[:search]}%")
    end

    if params[:start_date].present? && params[:end_date].present?
      start_date = params[:start_date]
      end_date = params[:end_date].to_date.end_of_day
      @orders = @orders.where(created_at: start_date..end_date)
    end

    if params[:state].present?
      @orders = @orders.where(state: params[:state])
    end

    if params[:genre].present?
      @orders = @orders.where(genre: params[:genre])
    end

    if params[:offer].present?
      @orders = @orders.where(offer_id: params[:offer])
    end
  end

  def update
    @order = Order.find(params[:id])  # Make sure you find the order you're working with

    case params[:commit]
    when 'Submit'
      handle_submit
    when 'Pay'
      handle_pay
    when 'Cancel'
      handle_cancel
    end
  end

  private

  def handle_submit
    if @order.may_submit?  # Assuming you have a 'may_submit?' method in your Order model
      @order.submit!
      flash[:notice] = 'Order submitted.'
    else
      flash[:error] = 'Unable to submit order.'
    end
    redirect_to admin_orders_index_path
  end

  def handle_pay
    if @order.may_pay?  # Assuming you have a 'may_pay?' method in your Order model
      @order.pay!
      flash[:notice] = 'Order paid.'
    else
      flash[:error] = 'Unable to pay order.'
    end
    redirect_to admin_orders_index_path
  end

  def handle_cancel
    if @order.may_cancel?  # Assuming you have a 'may_cancel?' method in your Order model
      @order.cancel!
      flash[:notice] = 'Order cancelled.'
    else
      flash[:error] = 'Unable to cancel order.'
    end
    redirect_to admin_orders_index_path
  end


end
