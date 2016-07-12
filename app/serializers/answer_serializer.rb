class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :user, :created_at

  def user
    object.user
  end

  def created_at
    object.created_at.strftime("%Y-%B-%d")
  end

end
