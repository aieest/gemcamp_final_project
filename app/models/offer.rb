class Offer < ApplicationRecord
  validates :name, presence: true
  validates :amount, presence: true
  validates :coin, presence: true
  enum status: { inactive: 0, active: 1 }

  mount_uploader :image, ImageUploader

  has_many :orders
end
