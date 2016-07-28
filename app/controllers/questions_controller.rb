class QuestionsController < ApplicationController
  before_action :find_question, only: [:show, :update, :destroy, :edit, :update]

  before_action :authorize_owner, only: [:edit, :update, :destroy]
  def new
    @question = Question.new
  end

  def create
    service = Questions::Create.new params: question_params,
                                user: current_user
    if service.call
      redirect_to question_path (service.question), notice: "Question created!"
    else
      @question = service.question
      flash[:alert] = "Question not created"
      render :new
    end
  end

  def show
    @question.increment!(:view_count)
    @answer = Answer.new
    respond_to do |format|
      format.html
      format.json { render json: {question: @question, answers: @question.answers}}
    end
  end

  def index
    respond_to do |format|
      @questions = @questions = Question.order(created_at: :desc).page(params[:page]).per(10)
      format.html { @questions }
      format.json { render json: @questions  }
    end
  end

  def edit
  end

  def update
    @question.slug = nil
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

  def current_user_vote
    @question.vote_for(current_user)
  end

  helper_method :current_user_vote

  private

  def question_params
    params.require(:question).permit(:title, :body, :category_id, :image, {tag_ids: []}, :tweet_it)
  end

  def find_question
    @question = Question.find(params[:id]).decorate
  end

  def authorize_owner
      redirect_to root_path, alert: "Acess denied" unless can? :manage, @question
  end
end
