class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    question = Question.find params[:question_id]
    like = Like.new(question: question, user: current_user)
    if like.save
      redirect_to question_path(question), notice: "Thanks for liking"
    else
      redirect_to question_path(question), alert: "Liked already"
    end
  end

  def destroy
    like = Like.find params[:id]
    question = Question.find params[:question_id]
    like.destroy if can? :destroy, Like
    redirect_to question_path(question), notice: "Unliked"
  end

  def index
    @questions = current_user.liked_questions
  end
end
