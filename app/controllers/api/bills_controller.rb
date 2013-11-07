class Api::BillsController < ApplicationController
  respond_to :json

  def create
    @bill = Bill.new(params[:bill])
    @bill.owner_id = current_user.owner_id

    if @bill.save
      render "show"
    else
      render json: { errors: @bill.errors.full_messages },
             status: 422
    end
  end

  def show
    @bill = Bill.where(id: params[:id]).includes(bill_splits: :debtor).first
    render "show"
  end
end
