class Api::UserGroupsController < ApplicationController
  def create
    @group = UserGroup.new(params[:user_group])
    @group.user_ids << current_user.id

    if @group.save
      render json: @group, methods: [:user_ids]
    else
      render json: { errors: @group.errors.full_messages }, status: 422
    end
  end

  def show
    @group = UserGroup.find(params[:id])
    render json: @group, methods: [:user_ids]
  end

  def index
    @groups = current_user.groups.includes(:user_group_memberships).all
    render json: @groups, methods: [:user_ids]
  end

  def update
    @group = UserGroup.find(params[:id])
    @group.update_attributes(params[:user_group])

    if @group.save
      render json: @group, methods: [:user_ids]
    else
      render json: { errors: @group.errors.full_messages }, status: 422
    end
  end      
end
