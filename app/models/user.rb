class User < ActiveRecord::Base
  # This will give us the needed functionalities needed for user authentication:
  # 1. It will add attribute accessors: password, password_confirmation
  # 2. It will add a validation for password presence and length of password (4..72)
  # 3. If password_confirmation is set, it will validate that it is the same as password
  # 4. It will add handy method for us to automatically has the password to the digest
  # field and compare the given password
  has_secure_password

  serialize :twitter_raw_data, Hash

  before_create :generate_api_key

  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify

  has_many :votes, dependent: :destroy
  has_many :voted_questions, through: :votes, source: :question

  has_many :likes, dependent: :destroy
  has_many :liked_questions, through: :likes, source: :question

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :first_name, presence: true, unless: :using_oauth?
  validates :last_name, presence: true, unless: :using_oauth?
  validates :email, presence: true,
             uniqueness: true,
             format: { with: VALID_EMAIL_REGEX },
             unless: :using_oauth?
  validates :uid, uniqueness: {scope: :provider}, if: :using_oauth?

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.create_from_twitter(twitter_data)
    user = User.new
    full_name = twitter_data["info"]["name"].split(" ")
    user.first_name = full_name.first
    user.last_name = full_name.last
    user.uid = twitter_data["uid"]
    user.provider = twitter_data["provider"]
    user.twitter_token = twitter_data["credentials"]["token"]
    user.twitter_secret = twitter_data["credentials"]["secret"]
    user.twitter_raw_data = twitter_data
    user.password = SecureRandom.urlsafe_base64
    user.save!
    user
  end

  def self.find_or_create_from_twitter(twitter_data)
    user = User.where(uid: twitter_data["uid"], provider: twitter_data["provider"]).first
    user = create_from_twitter(twitter_data) unless (user)
    user
  end

  def using_oauth?
    uid.present? && provider.present?
  end

  PROVIDER_TWITTER = "twitter"

  def using_twitter?
    using_oauth? && provider == PROVIDER_TWITTER
  end

  private

    def generate_api_key
      # begin
      #   self.api_key = SecureRandom.urlsafe_base64
      # end while User.exists?(api_key: api_key)

      loop do
        self.api_key = SecureRandom.urlsafe_base64
        break unless User.exists?(api_key: api_key)
      end
    end
end
