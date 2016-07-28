class Questions::Create
  include Virtus.model

  attribute :params, Hash
  attribute :user, User

  attribute :question, Question

  def call
    @question = Question.new params
    @question.user = user

    if @question.save
      send_tweet if @question.tweet_it
      true
    else
      false
    end
  end

  private

    def send_tweet
      begin
      client = Twitter::REST::Client.new do |config|
        config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
        config.access_token = user.twitter_token
        config.access_token_secret = user.twitter_secret
      end
      client.update("#{@question.title}")
    rescue => e
      # Notify admin
    end

end
