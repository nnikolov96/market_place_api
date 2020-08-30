require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:order) { FactoryBot.create(:order, user: user) }
  let!(:product) { FactoryBot.create(:product, :with_quantity, price: 10, user: user)}
  let(:second_product) { FactoryBot.create(:product, :with_quantity, price: 25, user: user)}
  describe 'validations' do

    it 'has a valid factory' do
      expect(order).to be_valid
    end


    it 'knows its total' do
      order.placements = [
        Placement.new(product_id: product.id, quantity: 2),
        Placement.new(product_id: second_product.id, quantity: 2)
        ]
      order.set_total!
      expect(order.total).to eq((product.price * 2)  + (second_product.price * 2 ))
    end

    it 'builds placements for the order' do
      order.build_placements_with_product_ids_and_quantities [
        { product_id: product.id, quantity: 2 },
        { product_id: second_product.id, quantity: 3 }
      ]
      order.save
      expect(order.products.count).to eq(2)
    end

    it 'does not create order when product quantity is not enough' do
      order.placements << Placement.new(product_id: product.id, quantity: ( 1 + product.quantity))
      expect(order).to_not be_valid
    end
  end
end
