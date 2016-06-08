class Question < ActiveRecord::Base

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