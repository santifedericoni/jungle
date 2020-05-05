class User < ActiveRecord::Base
  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, { presence: true, uniqueness: { case_sensitive: false } }
  validates :password, { presence: true, length: {within: 8..100} }

  def self.authenticate_with_credentials (email, password)
    email = email.strip
    user = User.where('lower(email) = ?', email.downcase).first

    if user && user.authenticate(password)
      return user
    else
      return nil
    end
  end
  
end