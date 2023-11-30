class Client::Me::WinningsController < ApplicationController
  before_action :authenticate_client_user!
  def index
    @winnings = current_client_user.winning_items.includes(:item, :ticket, address: [ :city, :barangay, :province ])
  end
end
