class Winner < ApplicationRecord
  validates :item_batch_count, presence: true
  validates :admin, presence: true, if: :admin_presence_required?
  validates :picture, presence: true, if: :delivered?
  validates :comment, presence: true, if: :delivered?

  mount_uploader :picture, ImageUploader

  belongs_to :item
  belongs_to :ticket
  belongs_to :user
  belongs_to :address, optional: true
  belongs_to :admin, class_name: 'User', optional: true
  before_create :set_batch_count

  include AASM

  aasm column: 'state' do
    state :won, initial: true
    state :claimed, :submitted, :paid, :shipped, :delivered, :shared, :published, :remove_published

    event :claim do
      transitions from: :won, to: :claimed, guard: :has_address?
    end

    event :submit do
      transitions from: :claimed, to: :submitted
    end

    event :pay do
      transitions from: :submitted, to: :paid
    end

    event :ship do
      transitions from: :paid, to: :shipped
    end

    event :deliver do
      transitions from: :shipped, to: :delivered
    end
    event :share do
      transitions from: :delivered, to: :shared
    end

    event :publish do
      transitions from: [:shared, :remove_published], to: :published
    end

    event :remove_publish do
      transitions from: :published, to: :remove_published
    end
  end

  private

  def set_batch_count
    return unless item

    self.item_batch_count = item.batch_count
  end

  def has_address?
    address.present?
  end

  def admin_presence_required?
    submitted? || paid? || delivered? || shared? || published? || remove_published?
  end
end