class Admin::TicketsController < ApplicationController
  before_action :set_ticket, only: :update

  def index
    @tickets = Ticket.includes(:item, :user).all
    @states = Ticket.aasm.states.map(&:name)

    if params[:search].present?
      @tickets = @tickets.joins(:item, :user).where("serial_number LIKE :search OR items.name LIKE :search OR users.email LIKE :search", search: "%#{params[:search]}%")
    end

    if params[:start_date].present? && params[:end_date].present?
      start_date = params[:start_date]
      end_date = params[:end_date].to_date.end_of_day
      @tickets = @tickets.where(created_at: start_date..end_date)
    end

    if params[:state].present?
      @tickets = @tickets.where(state: params[:state])
    end
  end

  def update
    if params[:commit] == 'Cancel'
      @ticket.cancel!
    end

    redirect_to tickets_path
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end
end
