class Product < ApplicationRecord
  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :orders, through: :placements

  validates :title, :user_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, presence: true

  scope :filter_by_title, lambda { |keyword| where('lower(title) LIKE ?', "%#{keyword.downcase}%")}
  scope :above_or_equal_to_price, lambda { |price| where('price >= ?', price) }
  scope :below_or_equal_to_price, lambda { |price| where('price <= ?', price) }
end
