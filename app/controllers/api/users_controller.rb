class Api::UsersController < ApplicationController
  respond_to :json

  def index
    @users = User.all
    @users_with_balances = current_user.user_ids_with_outstanding_balance
    render "index"
  end

  def show
    @user = User.find(params[:id])
    @splits = current_user.splits_with(@user)
    @balance = BillSplit.sum_for_user(@splits, current_user)
    render "show"
  end

  def settle
    other_user = User.find(params[:id])
    balance = current_user.balance_with(other_user)
    if balance > 0
      bill = Bill.create_settle!(current_user, other_user)
      render json: bill
    else
      render json: { errors: ["You can only settle with people who owe you."] },
             status: 422
    end
  end
end
