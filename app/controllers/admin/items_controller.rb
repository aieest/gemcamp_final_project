class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    @admin_user = current_admin_user
    @items = Item.all
  end


  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:notice] = 'Item created successfully'
      redirect_to admin_items_path
    else
      flash.now[:alert] = 'Item create failed'
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @item.update(item_params)
      flash[:notice] = 'Item updated successfully'
      redirect_to admin_items_path
    else
      flash.now[:alert] = 'Item update failed'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    flash[:notice] = 'Item destroyed successfully'
    redirect_to admin_items_path
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(
      :image,
      :name,
      :quantity,
      :minimum_tickets,
      :state,
      :batch_count,
      :online_at,
      :offline_at,
      :start_at,
      :status)
  end
end
