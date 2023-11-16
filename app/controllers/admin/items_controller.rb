class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_item, only: [:show, :edit, :update, :destroy, :start, :end, :pause, :cancel]

  def index
    @admin_user = current_admin_user
    @items = Item.all
    @categories = Category.all
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

  def start
    @item.start! if @item.may_start?
    redirect_to admin_items_path
  end

  def pause

    @item.pause! if @item.may_pause?
    redirect_to admin_items_path
  end

  def end

    @item.end! if @item.may_end?
    redirect_to admin_items_path
  end

  def cancel

    @item.cancel! if @item.may_cancel?
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
      :status,
      :deleted_at,
      category_ids: []
      )

  end
end
