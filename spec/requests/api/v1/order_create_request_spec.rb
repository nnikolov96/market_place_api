require 'rails_helper'

RSpec.describe "creates orders", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:product) { FactoryBot.create(:product, :with_quantity, user: user)}
  let(:second_product) { FactoryBot.create(:product, :with_quantity, user: user)}

  before do
    @order_params = { order: { 
      product_ids_and_quantities: [
        { product_id: product.id, quantity: 2 },
        { product_id: second_product.id, quantity: 3 },
      ]
    } }
  end
  context 'when logged in' do
    it 'creates an order' do
      post api_v1_orders_url,
      params: @order_params,
      headers: { Authorization: JsonWebToken.encode(user_id: user.id) }, as: :json
      expect(response).to have_http_status(:created)
    end
  end

  context 'when not logged in' do
    it 'does not create an order' do
      post api_v1_orders_url, params: @order_params, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end
end
