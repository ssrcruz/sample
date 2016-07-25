class User < ActiveRecord::Base
  # self refers to the current user
  attr_accessor :remember_token # an accessible attribute has been created
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 256}, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
  has_secure_password # adds functionality: saves securely hashed with password_digest, password and password_confirmation,
                      # authenticate method - determines if the password is valid
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true
  # lines 3 - 9 contain the complete implementation for secure passwords.
  # password_digest is the hashed version of the password, since it is constructed using bcrypt gem,
  # it is computationally impractical to use the digest to discover the original password.


  # returns the hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  # returns a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # using self ensures that assignment sets the user's remember_token attribute equal to the new_token
  # It then updates the remember_digest to the new remember_token
  # That way it remembers a user in the database for use in persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # This method authenticates the remember_token and checks if it matches the remember_digest
  # If the remember_digest is nil, the method will be ignored after hence, the return.
  # Returns true if the given token matches the digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # This method forgets a user
  def forget
    update_attribute(:remember_digest, nil)
  end
end
