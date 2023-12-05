class Client::SharesController < ApplicationController
  def index
    @shares = Winner.published.includes(:user)
  end
end
