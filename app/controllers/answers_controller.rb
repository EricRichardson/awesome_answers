class AnswersController < ApplicationController
  # before_action :authorize_owner, only: [:edit, :destroy, :update]
  def create
    @answer = Answer.new answer_params
    @question = Question.find params[:question_id]
    @answer.question = @question
    @answer.user = current_user

    respond_to do |format|
      if @answer.save
        AnswersMailer.notify_question_owner(@answer).deliver_later

        format.html { redirect_to question_path(@question), notice: "Answer created" }

        # format.js { render js: "alert('Does this browser support js?')" }

        format.js { render :create_success } # will look for a file with the name

      else
        format.html { render "/questions/show" }
        format.js { render :create_fail }
      end
    end
  end

  def destroy
    @question = Question.find params[:question_id]
    @answer = Answer.find params[:id]
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to question_path(@question), notice: "Question deleted" }
      # format.js { render :destroy_success }
      format.js { render }
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def authorize_owner
      redirect_to root_path, alert: "Acess denied" unless can? :manage, @answer
  end
end
