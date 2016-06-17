class QuestionsController < ApplicationController
  before_action :find_question, only: [:show, :update, :destroy, :edit, :update]
  before_action :authenticate_user!, except: [:show, :index]

  def new
    @question = Question.new
  end

  def create
    @question = Question.new question_params
    @question.user = current_user
    if @question.save
      flash[:notice] = "Question created!"
      redirect_to question_path @question
    else
      flash[:alert] = "Question not created"
      render :new
    end
  end

  def show
    @question.increment!(:view_count)
    @answer = Answer.new
  end

  def index
    @questions = Question.order(created_at: :desc)
  end

  def edit
  end

  def update
    if @question.update question_params
      redirect_to question_path(@question), notice: "Question updated"
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: "Question deleted!"
  end

  private

  def authenticate_user!
    redirect_to new_session_path, alert: "please sign in" unless user_signed_in?
  end

  def question_params
    params.require(:question).permit(:title, :body, :category_id)
  end

  def find_question
    @question = Question.find params[:id]
  end
end
