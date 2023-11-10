class Address::City < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :province
  has_many :barangays
  has_many :addresses
end
