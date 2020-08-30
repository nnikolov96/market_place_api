require 'rails_helper'

RSpec.describe "Api::V1::Products", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:product) { FactoryBot.create(:product, user: user) }

  it 'shows all products' do
    get api_v1_products_url, as: :json
    expect(response).to have_http_status(:success)

  end
  it 'shows a product' do
    get api_v1_product_url(product), as: :json
    expect(response).to have_http_status(:success)

    json_response = JSON.parse(self.response.body, symbolize_names: true)
    expect(json_response.dig(:data,:relationships, :user, :data, :id)).to eq product.user.id.to_s
    expect(json_response.dig(:included, 0, :attributes, :email)).to eq product.user.email
    expect(json_response.dig(:data, :attributes, :title)).to eq product.title
  end

  describe 'creates project' do
    context 'with valid token' do
      it 'creates product with valid attributes' do
        post api_v1_products_url, params: { product: {
          title: 'Test product',
          price: '10',
          published: true
        }},
        headers: { Authorization: JsonWebToken.encode(user_id: user.id) }, as: :json
        expect(response).to have_http_status(:created)
      end

      it 'does not create product with invalid attributes' do
        post api_v1_products_url, params: { product: {
          title: 'Test product',
          price: '-5',
          published: true
        }},
        headers: { Authorization: JsonWebToken.encode(user_id: user.id) }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with invalid token' do
      it 'does not create product with invalid token' do
        post api_v1_products_url, params: { product: {
          title: 'Test product',
          price: '10',
          published: true
        }}
        expect(response).to have_http_status(:forbidden)
      end

    end
  end
end
