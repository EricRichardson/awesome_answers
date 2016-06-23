class User < ActiveRecord::Base
  # This will give us the needed functionalities needed for user authentication:
  # 1. It will add attribute accessors: password, password_confirmation
  # 2. It will add a validation for password presence and length of password (4..72)
  # 3. If password_confirmation is set, it will validate that it is the same as password
  # 4. It will add handy method for us to automatically has the password to the digest
  # field and compare the given password
  has_secure_password

  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify

  has_many :votes, dependent: :destroy
  has_many :voted_questions, through: :votes, source: :question

  has_many :likes, dependent: :destroy
  has_many :liked_questions, through: :likes, source: :question

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true,
             uniqueness: true,
             format: { with: VALID_EMAIL_REGEX }

  def full_name
    "#{first_name} #{last_name}"
  end
end
