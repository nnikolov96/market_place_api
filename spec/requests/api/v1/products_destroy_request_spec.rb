require 'rails_helper'

RSpec.describe "destroy product", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:product) { FactoryBot.create(:product, user: user) }

  context 'by owner' do
    it 'is destroyed successfully by owner' do
      delete api_v1_product_url(product), headers: {
      Authorization: JsonWebToken.encode(user_id: product.user_id) }, as: :json
      expect(response).to have_http_status(:no_content)
    end
  end

  context 'unauthorized user' do
    it 'forbids destroy of product if not product owner' do
      other_user = User.create(email: 'Niki@gmail.com', password: 'Test1234#')
      delete api_v1_product_url(product), headers: {
      Authorization: JsonWebToken.encode(user_id: other_user.id) }, as: :json
      expect(response).to have_http_status(:forbidden)
    end
    it 'forbids destroy of product with invalid token' do
      delete api_v1_product_url(product)
      expect(response).to have_http_status(:forbidden)
    end
  end
end