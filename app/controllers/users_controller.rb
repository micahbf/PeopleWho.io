class UsersController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      self.current_user = @user
      redirect_to :root
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def show
    if params[:id] == current_user.id
      @user = current_user
      users_with_balances = @user.users_with_outstanding_balance
      @owed_users = users_with_balances.select { |_, bal| bal < 0 }
      @owing_users = users_with_balances.select { |_, bal| bal > 0 }
      render :show_self
    else
      @user = User.find(params[:id])
      @splits = current_user.splits_with(@user)
      @balance = BillSplit.sum_for_user(@splits, current_user)
      render :show_other
    end
  end
end
