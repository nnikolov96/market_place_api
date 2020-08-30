require 'rails_helper'

RSpec.describe Product, type: :model do
  let!(:product) { FactoryBot.create(:product, price: 101) }
  let!(:second_product) { FactoryBot.create(:product, price: 99, title: 'not in search tearm', user: product.user)}

  describe 'validations' do
    it 'has a valid factory' do
      expect(product).to be_valid
    end

    it 'is invalid with negative price' do
      product.price = -1
      expect(product).to_not be_valid
      expect(product.errors[:price]).to include('must be greater than or equal to 0')
    end
  end

  describe 'filtering' do
    it 'filters products by name' do
      products = Product.filter_by_title('Niki product')
      expect(products).to include(product)
      expect(products).to_not include(second_product)
    end

    it 'filters product with price above' do
      products = Product.above_or_equal_to_price(100)
      expect(products).to include(product)
      expect(products).to_not include(second_product)
    end

    it 'filters product with price bellow' do
      products = Product.below_or_equal_to_price(100)
      expect(products).to_not include(product)
      expect(products).to include(second_product)
    end

  end
end
