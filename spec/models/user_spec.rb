require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'Validations' do
    context 'on a new user' do

      before do
        @user = User.new password: 'password', password_confirmation: 'password', first_name: 'First', last_name: 'Last', email: 'email@email.com'
      end

      it 'should be able to save a new user' do
        expect(@user).to be_valid
      end

      it 'should not be valid without a password' do
        @user.password = nil
        expect(@user).not_to be_valid
      end

      it 'should be not be valid with a short password' do
        @user.password = 'short'
        @user.password_confirmation = 'short'
        expect(@user).not_to be_valid
      end

      it 'should not be valid with a confirmation mismatch' do
        @user.password_confirmation = 'otherpass'
        expect(@user).not_to be_valid
      end

      it 'should not be valid without password confirmation' do
        @user.password_confirmation = nil
        expect(@user).not_to be_valid
      end

      it 'should not be valid if the (not case sensitive) email is already registered' do
        @user.save!
        user2 = @user.dup
        user2.email = @user.email.upcase
        expect(user2).not_to be_valid
      end
    end
  end

  describe '.authenticate_with_credentials' do
    context 'when logging in' do

      before do
        @user = User.create! password: 'password', password_confirmation: 'password', first_name: 'First', last_name: 'Last', email: 'email@email.com'
      end

      it 'should return true when the correct password for a given email is entered' do
        user = User.authenticate_with_credentials(@user.email, @user.password)
        expect(user).to eq(@user)
      end

      it 'should return false when an incorrect password is entered for a given email' do
      user = User.authenticate_with_credentials(@user.email, 'otherpass')
      expect(user).not_to eq(@user)
      end
    end
  end

end