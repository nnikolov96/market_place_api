require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { FactoryBot.create(:product) }
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
end
