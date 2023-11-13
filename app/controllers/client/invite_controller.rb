class Client::InviteController < ApplicationController
  before_action :authenticate_client_user!
  def index
    require "rqrcode"

    @qrcode = RQRCode::QRCode.new("client.com:3000/users/sign_up?promoter=#{current_client_user.email}")
    @svg = @qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true,
      viewbox: true
    )
  end
end
