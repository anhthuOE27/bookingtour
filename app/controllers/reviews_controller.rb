class ReviewsController < ApplicationController
  layout "layouts/reviews"

  before_action :load_tour, only: [:create, :new]
  before_action :load_review, only: [:destroy, :show]
  before_action :correct_user_for_review, only: :destroy

  def show
    return if @review
    flash[:danger] = t "controllers.reviews.show.danger"
    redirect_to root_path
  end

  def new
    @review = @tour.reviews.new
  end

  def create
    @review = current_user.reviews.build(content: params[:review][:content],
      tour: @tour)
    @files = params[:review][:image]
    ActiveRecord::Base.transaction do
      @review.save
      if @files.present?
        save_picture
      end
      flash[:success] = t "controllers.reviews.create.success"
      redirect_to current_user
    end
  rescue StandardError
    flash[:danger] = t "controllers.reviews.create.fail"
    render :new
  end

  def index
    @reviews = Review.includes_user_and_tour.sort_by_created_at.paginate page:
      params[:page], per_page: Settings.tour.length
  end

  def destroy
    if @review.destroy
      flash[:success] = t "controllers.reviews.destroy.success"
      redirect_to request.referrer
    else
      flash[:danger] = t "controllers.reviews.danger"
      redirect_to request.referrer || root_url
    end
  end

  private

  def review_params
    params.require(:review).permit(:content)
  end

  def load_tour
    @tour = Tour.find_by id: params[:tour_id]
    return if @tour
    flash[:danger] = t "controllers.reviews.load_tour.danger"
    redirect_to root_path
  end

  def load_review
    @review = Review.find_by id: params[:id]
    return if @review
    flash[:danger] = t "controllers.reviews.notfound"
    redirect_to root_path
  end

  def correct_user_for_review
    @user = @review.user
    return if current_user? @user
    flash[:danger] = t "controllers.reviews.notfound"
    redirect_to request.referrer || root_url
  end

  def save_picture
    @files.map do |file|
      @review.imagerelations.create(user: current_user, picture: file)
    end
  end
end
