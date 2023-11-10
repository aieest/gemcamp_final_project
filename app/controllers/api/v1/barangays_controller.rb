class Api::V1::BarangaysController < ApplicationController
  def index
    city = Address::City.find_by_id(params[:city_id])
    barangays = if city
                  city.barangays
                else
                  Address::Barangay.includes(:city).all
                end
    render json: barangays, each_serializer: BarangaySerializer
  end

  def show
    barangay = Address::Barangay.find(params[:id])
    render json: barangay, serializer: BarangaySerializer
  end
end