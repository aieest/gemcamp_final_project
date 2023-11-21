class Item < ApplicationRecord

  mount_uploader :image, ImageUploader

  default_scope { where(deleted_at: nil) }
  # validates :image, presence: true
  validates :name, presence: true
  validates :quantity, presence: true
  validates :minimum_tickets, presence: true
  # validates :state, presence: true
  validates :batch_count, presence: true
  validates :online_at, presence: true
  validates :offline_at, presence: true
  validates :start_at, presence: true
  # validates :status, presence: true
  has_many :item_category_ships
  has_many :categories, through: :item_category_ships

  def destroy
    if tickets.present?
      errors.add(:base, "Cannot delete item with associated tickets")
      false
    else
      update(deleted_at: Time.current)
    end
  end

  has_many :item_category_ships, dependent: :restrict_with_error
  has_many :categories, through: :item_category_ships
  has_many :tickets
  has_many :winners


  enum status: { inactive: 0, active: 1 }

  include AASM

  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], guard: :before_start, to: :starting, after: :after_start
      transitions from: :paused, to: :starting, after: :after_start
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended, guard: :exceeded_max_bets?, after: :set_winner
    end

    event :cancel do
      transitions from: :starting, to: :cancelled, after: [:revert_quantity, :cancel_all_tickets]
    end
  end

  private

  def exceeded_max_bets?
    return true if tickets.pending.count >= minimum_tickets
    errors.add(:base, 'Have not reached minimum tickets.')
    false
  end

  def set_winner
    winning_ticket = tickets.pending.sample
    tickets.pending.each do |ticket|
      if ticket == winning_ticket
        ticket.win!
      else
        ticket.lose!
      end
    end

    winner = winners.build do |w|
      w.ticket = winning_ticket
      w.user = winning_ticket.user
      w.address = winning_ticket.user.addresses.default
      w.item_batch_count = batch_count
    end
    winner.save
  end

  def before_start
    unless quantity.to_i.positive? && (offline_at.nil? || Time.current < offline_at) && status.to_s == 'active'
      return false
    end
    true
  end

  def cancel_all_tickets
    tickets.each do |ticket|
      ticket.cancel!
    end
  end


  def after_start
    self.quantity -= 1
    self.batch_count += 1
    save!
  end
end
