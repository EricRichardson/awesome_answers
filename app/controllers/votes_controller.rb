class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    @vote = Vote.new vote_params
    @vote.user = current_user
    @vote.question = current_question

    respond_to do |format|
      if @vote.save

        format.html { redirect_to current_question, notice: "Thanks for voting" }

        format.js { render :create_success }

      else

        format.html { redirect_to current_question, alert: "An Error has occured" }

        format.js { render :create_failure }

      end
    end
  end

  def update
    @vote = Vote.find_by_id params[:id]
    respond_to do |format|
      if @vote
        @vote.update vote_params
        format.html{ redirect_to current_question, notice: "Vote changed" }

        format.js { render }
      else
        format.html{ redirect_to current_question } # case if vote has been deleted
        format.js { render }
      end
    end
  end

  def destroy
    @vote = Vote.find_by_id params[:id]

    respond_to do |format|
      if @vote
        @vote.destroy
        format.html { redirect_to current_question, notice: "Vote removed" }
        format.js { render }
      else
        format.html { redirect_to current_question }
        format.js { render }
      end
    end
  end

  private
    def vote_params
      params.require(:vote).permit(:is_up)
    end


end
