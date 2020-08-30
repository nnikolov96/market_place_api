require 'rails_helper'

RSpec.describe "update product", type: :request do

  let(:user) { FactoryBot.create(:user) }
  let(:product) { FactoryBot.create(:product, user: user) }

  context 'with valid token' do
    it 'updates product with valid attributes' do
      patch api_v1_product_url(product),
      params: { product: { title: 'new title' }},
      headers: { Authorization: JsonWebToken.encode(user_id: user.id) }, as: :json
      expect(response).to have_http_status :success
    end

    it 'does not update product with invalid attributes' do
      patch api_v1_product_url(product),
      params: { product: { price: -5 }},
      headers: { Authorization: JsonWebToken.encode(user_id: user.id) }, as: :json
      expect(response).to have_http_status :unprocessable_entity
    end

    it 'does not update product that doesnt belong to user' do
      other_user = User.create(email: 'test_user@gmail.com', password: 'test1234#')
      patch api_v1_product_url(product),
      params: { product: { price: -5 }},
      headers: { Authorization: JsonWebToken.encode(user_id: other_user.id) }, as: :json
      expect(response).to have_http_status :forbidden
    end
  end
  
  context 'with invalid token' do
    it 'does not update product with invalid token' do
      patch api_v1_product_url(product),
      params: { product: { price: -5 }}
      expect(response).to have_http_status :forbidden
    end
  end
end