class CommentsController < ApplicationController
  before_action :logged_in_user, only: :create

  def create
    @tour = Tour.find_by id: params[:tour_id]
    if params[:comment][:content].present? && @tour
      build_comment
    else
      flash[:danger] = "fail"
      redirect_to root_url
    end
  end

  private

  def build_comment
    current_user.comments.create(content: params[:comment][:content],
    parent_comment: params[:comment_id], commentable: @tour)
    redirect_to request.referrer || root_url
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "controllers.users.danger"
    redirect_to login_url
  end
end
