class User < ActiveRecord::Base

  # an accessible attribute
  attr_accessor :remember_token, :activation_token
  # use the private methods in this class
  before_save   :downcase_email
  before_create :create_activation_digest

  # make sure the name isn't blank, isn't too long
  # make sure the email is in (kind of) proper format
  # make sure the password is valid, long enough, etc.
  # don't create a new user if one of these fails
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: {case_sensitive: false}
  has_secure_password
  # We allow nil so that the user can update info without providing a password
  # This won't allow users to sign up without a password because of has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # we'll be using this method more than once, so we put it here
  # this will allow us to create fixtures, so we can test our code with
  # usernames/passwords that always exist in the database
  # we need a fixture password, because user's have a field known as password_digest
  # we use minimum cost for fixtures(testing) and high cost for actual production
  # this is a "class method" !

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # creates a 'remember token' out of a random string of length 22
  # uses the SecureRandom module provided by Ruby and the corresponding method
  # this is similar to the password_digest

  # Returns a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # we generated the remember_digest column after, using
  # rails generate migration add_remember_d...
  #CH8

  # like passwords, we want the remember_digest (like the password_digest)
  # to be stored in the database, but we don't want remember_token or password
  # to be in the database (yet we want remember_token to be stored in the cookies)

  # Remembers a user in the database for us in persistent sessions
  def remember
    # give the variable to "self", the user
    # sets the remember_token attribute of the user object
    self.remember_token = User.new_token
    # update attribute of the User, bypass validations (password), hash the
    # remember_token using digest (not totally sure that's right)
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Returns true if the given token matches the digest
  # First version scrapped: second version allows us to generalize the authenticated? method

  # The point of BCrypt is to hash the token to make this irreversible
  # Cookies will store remember_token and encrypted User ID to stay logged in
  #def authenticated?(remember_token)
    # don't let the system crash when remember_token is not null, but remember_digest is!
    # two browser scenario
    #return false if remember_digest.nil?
    #BCrypt::Password.new(remember_digest).is_password?(remember_token)
  #end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  # removes the remember_digest (the hashed one)
  def forget
    update_attribute(:remember_digest, nil)
  end

  private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
