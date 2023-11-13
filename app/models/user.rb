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

end
