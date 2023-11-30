class Client::Me::InvitesController < ApplicationController
  def index
    @invites = current_client_user.children
  end
end
