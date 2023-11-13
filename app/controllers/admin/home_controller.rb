class Admin::HomeController < ApplicationController
  before_action :authenticate_admin_user!
  def index

    @client_users = User.client.includes(:children).with_children_total_deposit
  end

end
