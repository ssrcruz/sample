class User < ActiveRecord::Base
  # self refers to the current user
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 256}, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
  has_secure_password # adds functionality: saves securely hashed with password_digest, password and password_confirmation,
                      # authenticate method - determines if the password is valid
  validates :password, presence: true, length: {minimum: 6}
  # lines 3 - 9 contain the complete implementation for secure passwords.
  # password_digest is the hashed version of the password, since it is constructed using bcrypt gem,
  # it is computationally impractical to use the digest to discover the original password.
end
