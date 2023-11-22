class Admin::OffersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_offer, except: [:index, :new, :create]

  def index
    @offers = Offer.all
  end

  def show
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      flash[:notice] = 'Offer created!'
      redirect_to admin_offers_path
    else
      flash.now[:alert] = 'Offer creation failed.'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @offer.update(offer_params)
      flash[:notice] = 'Offer updated!'
      redirect_to admin_offers_path(@offer)
    else
      flash.now[:alert] = 'Offer update failed.'
      render :edit
    end
  end

  def destroy
    @offer.destroy
    flash[:notice] = 'Offer deleted.'
    redirect_to admin_offers_path
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def offer_params
    params.require(:offer).permit(:image, :name, :status, :amount, :coin)
  end
end
