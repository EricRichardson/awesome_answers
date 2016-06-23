class AnswersController < ApplicationController
  before_action :authorize_owner, only: [:edit, :destroy, :update]
  def create
    @answer = Answer.new answer_params
    @question = Question.find params[:question_id]
    @answer.question = @question
    @answer.user = current_user
    if @answer.save
      AnswersMailer.notify_question_owner(@answer).deliver_later
      redirect_to question_path(@question), notice: "Answer created"
    else
      render "/questions/show"
    end
  end

  def destroy
    @question = Question.find params[:question_id]
    @answer = Answer.find params[:id]
    @answer.destroy
    redirect_to question_path(@question), notice: "Question deleted"
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def authorize_owner
      redirect_to root_path, alert: "Acess denied" unless can? :manage, @answer
  end
end
