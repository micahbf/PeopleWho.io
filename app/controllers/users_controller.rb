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
    if params[:id] = current_user.id
      @user = current_user
      render :show_self
    else
      @user = User.find(params[:id])
      render :show_other
    end
  end
end
