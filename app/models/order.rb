class Order < ApplicationRecord
  belongs_to :product
  belongs_to :supplier, optional: true

  validates :customer_name, presence: true
end
