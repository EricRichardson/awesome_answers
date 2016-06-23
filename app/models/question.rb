class Question < ActiveRecord::Base
  # has_many helps us set up the association between question model and the answer model. In this case 'has_many' assumes that the answers table contains a field named 'question_id' that is an integer (this is a Rails convention). The dependent option takes values like 'destory' and 'nullify'
  # 'destroy' will make Rails automatically delete the associated answers before deleteing the question.
  #'nullify' will make Rails turn 'question_id' values of associated records to NULL before deleting the question
  has_many :answers, dependent: :destroy
  belongs_to :category
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user

  has_many :votes, dependent: :destroy
  has_many :voting_users, through: :votes, source: :user

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  validates(:title, {presence: {message: "must be present!"}, uniqueness: true})

  validates :body, presence: true,
             length:     {minimum: 7},
             uniqueness: {scope: :title}

  validates :view_count, numericality: {greater_than_or_equal_to: 0}
  validate :no_monkey
  validate :title_not_in_body

  after_initialize :set_defaults

  before_validation :cap_title, :squeeze_text
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  # validates :email, format: VALID_EMAIL_REGEX

  def self.recent(count)
    where("created_at > ?", 3.day.ago).limit(count)
  end
  # scope :recent, lambda {|count| where("created_at > ?", 3.day.ago).limit(count)}

  def self.search (term)
    where("title ILIKE ? or body ILIKE ?", "%#{term}%", "%#{term}%")
  end

  def new_first_answer
    answers.order(created_at: :desc)
  end

  def liked_by?(user)
    likes.exists?(user: user)
  end

  def like_for(user)
    likes.find_by_user_id user
  end

  def voted_by?(user)
    votes.exists?(user: user)
  end

  def vote_for(user)
    votes.find_by_user_id user
  end

  def voted_up_by?(user)
    voted_by?(user) && vote_for(user).is_up?
  end

  def voted_down_by?(user)
    voted_by?(user) && !vote_for(user).is_up?
  end

  def up_votes
    votes.where(is_up: true).count
  end

  def down_votes
    votes.where(is_up: false).count
  end

  def vote_sum
    up_votes - down_votes
  end
  
  private

    def set_defaults
      self.view_count ||= 0
    end

    def cap_title
      self.title = title.capitalize
    end

    def squeeze_text
      self.title = title.squeeze
      self.body = body.squeeze
    end

    def no_monkey
      if title && title.downcase.include?("monkey")
        errors.add(:title, "No monkeys please!")
      end
    end

    def title_not_in_body
      if body.include?(title)
        errors.add(:body, "No title in body please")
      end
    end
end
