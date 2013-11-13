class SessionsController < ApplicationController
  before_filter :require_no_current_user!, :only => [:create, :new]
  before_filter :require_current_user!, :only => [:destroy]
  
  def new
    render :new
  end

  def create
    user = User.find_by_credentials(
      params[:user][:email],
      params[:user][:password]
    )

    if user
      self.current_user = user
      redirect_to root_url
    else
      flash.now[:errors] = "Invalid email/password"
      render :new
    end
  end

  def destroy
    logout_current_user!
    redirect_to root_url
  end
end
