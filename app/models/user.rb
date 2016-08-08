class User < ActiveRecord::Base
  # self refers to the current user
  attr_accessor :remember_token, :activation_token, :reset_token # an accessible attribute has been created
  before_save :downcase_email
  before_create :create_activation_digest
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

  # This method authenticates the digest and checks if it matches the token
  # If the digest is nil, the method will return false.
  # Returns true if the given token matches the digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # This method forgets a user
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # sets the password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # sends password reset email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  # returns true if password_reset has expired
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private
  # converts email to all lowercase
  def downcase_email
    self.email = email.downcase
  end
  # creates and assigns the activation token and digest
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
