class Client::LotteryController < ApplicationController
  def index
    @categories = Category.all

    if params[:commit] != 'All' || !params[:commit].present?
      @items = Category.find_by_name(params[:commit]).items.limit(4)
    else
      @items = Item.starting.includes(:categories).limit(4)
    end
  end
end
