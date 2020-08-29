require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }
  describe 'validations' do
    it 'has a valid factory' do
      expect(user).to be_valid
    end

    it 'is not valid without email' do
      user.email = nil
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include "is invalid"
    end
    it 'has to have unique email' do
      User.create!(email: user.email, password_digest: 'Test1234#')
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include 'has already been taken'
    end
  end
end
