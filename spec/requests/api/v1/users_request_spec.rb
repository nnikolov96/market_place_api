require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let(:user) { FactoryBot.create(:user) }

  it 'shows user' do
    get api_v1_user_url(user), as: :json
    expect(response).to have_http_status(:success)

    json_response = JSON.parse(response.body, symbolize_names: true)
    expect(json_response.dig(:data, :attributes, :email)).to eq user.email
  end

  describe 'creates user' do
    it 'creates user with unique email' do
      user_attributes = FactoryBot.attributes_for(:user)
      post api_v1_users_url, params: { user: user_attributes }, as: :json
      expect(response).to have_http_status(:created)
    end

    it 'does not create user with already taken email' do
      user_attributes = FactoryBot.attributes_for(:user, email: user.email)
      post api_v1_users_url, params: { user: user_attributes }, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'updates user' do
    context 'with valid attributes' do
      it 'updates user' do
        patch api_v1_user_url(user),
        params: { user: { email: user.email, password: 'Test1234#'} },
        headers: { Authorization: JsonWebToken.encode(user_id: user.id) },
        as: :json
        expect(response).to have_http_status(:success)
      end
    end
    context 'with invalid attributes' do
      it 'does not update the user' do
        patch api_v1_user_url(user), params: { user: { email: 'badmail'} }, as: :json
        expect(response).to have_http_status(:forbidden)
      end
    end

  end

  describe 'deletes user' do

    context 'with authorization header' do
      it 'deletes user' do
        user_to_delete = User.create(email: 'Test1234@gmail.com', password: 'Test1234#')
        expect do
          delete api_v1_user_url(user_to_delete),
          headers: { Authorization: JsonWebToken.encode(user_id: user_to_delete.id) },
          as: :json
        end.to change{User.count}.by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'without authorization header' do
      it 'forbids to delete user' do
        user_to_delete = User.create(email: 'Test1234@gmail.com', password: 'Test1234#')
        delete api_v1_user_url(user_to_delete)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
