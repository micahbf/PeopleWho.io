class Api::BillsController < ApplicationController
  respond_to :json

  def create
    @bill = Bill.new(params[:bill])
    @bill.owner_id = current_user.id

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

  def index
    own_bills = current_user.paid_bills.includes(:bill_splits)
    others_bills = Bill.includes(:bill_splits).where("bill_splits.debtor_id" => current_user.id)

    @bills = own_bills.concat(others_bills)
    render "index"
  end
end
