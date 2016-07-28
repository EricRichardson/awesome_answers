class Api::V1::AnswersController < Api::BaseController


  def create
    question = Question.find params[:question_id]
    answer = Answer.new answer_params
    answer.question = question
    answer.user = @user
    if answer.save
      render json: {success: true}
    else
      errors = answer.errors.full_messages.join(", ")
      render json: {errors: errors}
    end
  end

  private

    def answer_params
      params.require(:answer).permit(:body)
    end


end
