class Admin::TicketsController < ApplicationController
  before_action :set_ticket, only: :update

  def index
    @tickets = Ticket.includes(:item, :user).all
    @states = Ticket.aasm.states.map(&:name)

    if params[:search].present?
      filtered_serial_number = @tickets.where('serial_number LIKE :search', search: "%#{params[:search]}%")
      @tickets = filtered_serial_number if filtered_serial_number.present?

      filtered_item_name = @tickets.joins(:item).where("items.name LIKE :search", search: "%#{params[:search]}%")
      @tickets = filtered_item_name if filtered_item_name.present?

      filtered_email = @tickets.joins(:user).where("users.email LIKE :search", search: "%#{params[:search]}%")
      @tickets = filtered_email if filtered_email.present?
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
