class QuestionsController < ApplicationController

  def new
    @question = Question.new
  end

  def create
    question_params = params.require(:question).permit(:title, :body)
    @question       = Question.new question_params
    if @question.save
      redirect_to question_path @question
    else
      render :new
    end
  end

  def show
    @question = Question.find params[:id]
    @question.increment!(:view_count)
  end

  def index
    @questions = Question.order(created_at: :desc)
  end

  def edit
    @question = Question.find params[:id]
  end

  def update
    @question = Question.find(params[:id])
    question_params = params.require(:question).permit(:title, :body)
    if @question.update question_params
      redirect_to question_path(@question)
    else
      render :edit
    end
  end

  def destroy
    @question = Question.find params[:id]
    @question.destroy
    redirect_to questions_path
  end
end
