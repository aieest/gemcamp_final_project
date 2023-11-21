class Admin::WinnersController < ApplicationController
  def index
    @states = Winner.aasm.states.map(&:name)
    @winners = Winner.all.includes(:user, :item, :ticket, address: [:city, :province])

    if params[:search].present?
      @winners = @winners.joins(:user, :ticket).where("users.email LIKE :search OR tickets.serial_number LIKE :search", search: "%#{params[:search]}%")
    end

    if params[:start_date].present? && params[:end_date].present?
      start_date = params[:start_date]
      end_date = params[:end_date].to_date.end_of_day
      @winners = @winners.where(created_at: start_date..end_date)
    end

    if params[:state].present?
      @winners = @winners.where(state: params[:state])
    end
  end
end
