class ToursController < ApplicationController
  def index
    @tours = Tour.sort_by_created_at.paginate page: params[:page],
      per_page: Settings.tour.length
  end

  def show
    @tours = Tour.find_by id: params[:id]
    @comments = @tours.comments.sort_by_created_at
    return if @tours
    flash[:danger] = t "controllers.reviews.notfound"
    redirect_to root_path
  end
end
