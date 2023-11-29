class Client::Me::OrdersController < ApplicationController
  before_action :authenticate_client_user!
  def index
    @orders = current_client_user.orders
  end
end
