class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :path, :view_count

  has_many :answers

  def path
    question_path(object)
  end

    include ApplicationHelper
    include Rails.application.routes.url_helpers
end
