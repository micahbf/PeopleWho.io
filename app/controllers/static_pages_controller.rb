class StaticPagesController < ApplicationController
  def root
    if current_user
      @current_user_id = current_user.id
      @users = User.all
      @users_with_balances = current_user.user_ids_with_outstanding_balance
      render :root
    else
      redirect_to new_session_url
    end
  end
end
