class Client::Me::LotteriesController < ApplicationController
  def index
    @lotteries = current_client_user.tickets.includes(:item)
  end
end
