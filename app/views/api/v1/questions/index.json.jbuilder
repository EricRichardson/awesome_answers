json.array! @questions do |question|
  json.id question.id
  json.title question.title
  json.created_at question.created_at.strftime("%Y-%B-%d")
  json.path api_v1_question_path(question)
  json.category question.category_name if question.category
  json.user do
    json.first_name question.user_first_name
    json.last_name question.user_last_name
  end

  json.answers question.answers do |answer|
    json.body answer.body
  end
end
