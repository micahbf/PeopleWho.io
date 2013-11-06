class BillsController < ApplicationController
  def new
    @bill = Bill.new
    render :new
  end

  def create
    @bill = Bill.new(params[:bill])
    @bill.owner_id = current_user.id
    
    if @bill.save
      flash[:notices] = "Bill saved."
      redirect_to :index
    else
      flash.now[:errors] = @bill.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def index
    redirect_to user_url(current_user)
  end

  def show
    @bill = Bill.find(params[:id]).includes(bill_splits: :debtors)
    render :show
  end
end
