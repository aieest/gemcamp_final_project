class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # validates :attribute, phone: { possible: true, allow_blank: true, types: [:voip, :mobile], country_specifier: -> phone { phone.country.try(:upcase) } }
  enum role: {client: 0, admin: 1}

  belongs_to :parent, class_name: 'User', optional: true, counter_cache: :children_members
  has_many :children, class_name: 'User', foreign_key: 'parent_id'
  has_many :addresses
  has_many :tickets
  has_many :winning_items, class_name: 'Winner', foreign_key: 'user_id'
  has_many :bought_items, class_name: 'Winner', foreign_key: 'admin_id'
  has_many :orders

  scope :with_children_total_deposit, -> {
    joins("LEFT JOIN users AS children ON children.parent_id = users.id")
      .group("users.id")
      .select("users.*, COALESCE(SUM(children.total_deposit), 0) AS children_total_deposit")
  }
end
