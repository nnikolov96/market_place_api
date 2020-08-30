require 'rails_helper'

RSpec.describe "Api::V1::Orders", type: :request do
  let!(:order) { FactoryBot.create(:order) }
  let!(:other_order) { FactoryBot.create(:order, user: order.user) }

  it 'forbids orders for unlogged user' do
    get api_v1_orders_url, as: :json
    expect(response).to have_http_status(:forbidden)
  end

  it 'show orders for logged user' do
    get api_v1_orders_url, 
    headers: { Authorization: JsonWebToken.encode(user_id: order.user_id) }, as: :json
    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body)
    expect(json_response['data'].count).to eq(order.user.orders.count)
  end

  it 'shows a specific order' do
    get api_v1_order_url(order),
    headers: { Authorization: JsonWebToken.encode(user_id: order.user_id) }, as: :json
    expect(response).to have_http_status(:success)
  end
end
