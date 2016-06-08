class BillSplitterController < ApplicationController
  def index
  end

  def split
    @bill = params[:bill_total].to_f
    @tax = params[:tax].to_i
    @tip = params[:tip].to_i
    @people = params[:people].to_i
    @total = '%.2f' % ((@bill + (@bill * @tax/100) + (@bill *@tip/100) )/ @people)
    render :index
  end
end
