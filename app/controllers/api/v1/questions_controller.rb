class Api::V1::QuestionsController < ApplicationController
  DEFAULT_PER_PAGE = 7

  def index
    @questions = Question.order(created_at: :desc).page(params[:page]).per(params[:per]) || DEFAULT_PER_PAGE
  end

  def show
    question = Question.find params[:id]
    question_json = ActiveModelSerializers::SerializableResource.new(question)
    render json: {question: question_json}
  end
end
