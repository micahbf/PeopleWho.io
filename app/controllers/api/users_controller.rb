class Api::UsersController < ApplicationController
  respond_to :json

  def show
    @user = User.find(params[:id])
    @splits = current_user.splits_with(@user)
    @balance = BillSplit.sum_for_user(@splits, current_user)
    render "show"
  end
end
