class Item < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  validates :image, presence: true
  validates :name, presence: true
  validates :quantity, presence: true
  validates :minimum_tickets, presence: true
  validates :state, presence: true
  validates :batch_count, presence: true
  validates :online_at, presence: true
  validates :offline_at, presence: true
  validates :start_at, presence: true
  validates :status, presence: true

  def destroy
    update(deleted_at: Time.current)
  end

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships
end
