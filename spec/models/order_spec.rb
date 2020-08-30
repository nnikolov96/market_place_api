require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:order) { FactoryBot.create(:order, user: user) }
  let(:product) { FactoryBot.create(:product, price: 10, user: user)}
  let(:second_product) { FactoryBot.create(:product, price: 25, user: user)}
  describe 'validations' do

    it 'has a valid factory' do
      expect(order).to be_valid
    end


    it 'knows its total' do
      order.product_ids = [product.id, second_product.id]
      order.save
      expect(order.total).to eq(product.price + second_product.price)
    end
  end
end
