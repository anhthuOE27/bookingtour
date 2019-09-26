class CommentsController < ApplicationController
  before_action :logged_in_user, only: :create

  def create
    @tour = Tour.find_by id: params[:tour_id]
    @review = Review.find_by id: params[:review_id]
    @commentable = @tour
    @commentable ||= @review
    if params[:comment][:content].present? && @tour || params[:comment][:content].present? && @review
      build_comment
    else
      flash[:danger] = "fail"
      redirect_to root_url
    end
  end

  private

  def build_comment
    current_user.comments.create(content: params[:comment][:content],
      parent_comment: params[:comment_id], commentable: @commentable)
    redirect_to request.referrer || root_url
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "controllers.users.danger"
    redirect_to login_url
  end
end
