require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    subject do
      described_class.new(
        first_name: 'Bacon',
        last_name: 'Gibson',
        email: 'baconTheDog@mail.com',
        password: 'thisIsAPassword',
        password_confirmation: 'thisIsAPassword'
      )
    end

    it 'is valid with all valid attributes present' do
      expect(subject).to be_valid
    end

    it 'is not valid without a first name' do
      subject.first_name = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include(
        "First name can't be blank"
      )
    end
    it 'is not valid without a last name' do
      subject.last_name = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include(
        "Last name can't be blank"
      )
    end
    it 'is not valid without an email' do
      subject.email = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Email can't be blank")
    end

    it 'is not valid with an email that is already in use' do
      @other_user =
        User.new(
          first_name: 'Francis',
          last_name: 'Baocon',
          email: 'baconTheDog@mail.com',
          password: 'thisIsAPassword',
          password_confirmation: 'thisIsAPassword'
        )
      @other_user.save

      expect(@other_user).to be_valid

      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include(
        'Email has already been taken'
      )
    end

    it 'is not valid with an email that is already in use (case insensitive)' do
      @other_user =
        User.new(
          first_name: 'Francis',
          last_name: 'Baocon',
          email: 'BACONTHEDOG@mail.com',
          password: 'thisIsAPassword',
          password_confirmation: 'thisIsAPassword'
        )
      @other_user.save

      expect(@other_user).to be_valid

      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include(
        'Email has already been taken'
      )
    end

    it 'is not valid when the password is missing' do
      subject.password = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Password can't be blank")
    end

    it 'is not valid when the password does not match the password confirmation' do
      subject.password_confirmation = 'ThisIsNotTHeSamePassword'
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include(
        "Password confirmation doesn't match Password"
      )
    end

    it 'is not valid with a password less than 8 characters long' do
      subject.password = 'short'
      subject.password_confirmation = 'short'
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include(
        'Password is too short (minimum is 8 characters)'
      )
    end
  end

  describe '.authenticate_with_credentials' do
    it 'returns the existing user when supplied with the correct email and password' do
      @existing_user =
        User.new(
          first_name: 'Francis',
          last_name: 'Baocon',
          email: 'baconTheDog@mail.com',
          password: 'thisIsAPassword',
          password_confirmation: 'thisIsAPassword'
        )
      @existing_user.save

      session =
        User.authenticate_with_credentials(
          @existing_user.email,
          @existing_user.password
        )

      expect(session).to eq(@existing_user)
    end

    it 'returns nil when supplied with the correct email but incorrect password' do
      @existing_user =
        User.new(
          first_name: 'Francis',
          last_name: 'Baocon',
          email: 'baconTheDog@mail.com',
          password: 'thisIsAPassword',
          password_confirmation: 'thisIsAPassword'
        )
      @existing_user.save

      session =
        User.authenticate_with_credentials(
          @existing_user.email,
          'wrongPassword'
        )

      expect(session).to be_nil
    end

    it 'returns correct user when supplied an email with extra spaces' do
      @existing_user =
        User.new(
          first_name: 'Francis',
          last_name: 'Baocon',
          email: 'baconTheDog@mail.com',
          password: 'thisIsAPassword',
          password_confirmation: 'thisIsAPassword'
        )
      @existing_user.save

      session =
        User.authenticate_with_credentials(
          ' baconTheDog@mail.com  ',
          @existing_user.password
        )

        expect(session).to eq(@existing_user)
    end

    it 'returns correct user when supplied an email with diffent cases' do
      @existing_user =
        User.new(
          first_name: 'Francis',
          last_name: 'Baocon',
          email: 'baconTheDog@mail.com',
          password: 'thisIsAPassword',
          password_confirmation: 'thisIsAPassword'
        )
      @existing_user.save

      session =
        User.authenticate_with_credentials(
          'BACONTHEDOG@mail.com',
          @existing_user.password
        )
        
        expect(session).to eq(@existing_user)
    end
  end
end