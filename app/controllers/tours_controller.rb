class ToursController < ApplicationController
  def index
    @prices = Tour.select(:price).map(&:price).uniq
    @categorts = Category.all
    return if load_tours.present?
    flash[:danger] = "Not found for codition"
  end

  def show
    @tours = Tour.find_by id: params[:id]
    @comments = @tours.comments.sort_by_created_at
    return if @tours
    flash[:danger] = t "controllers.reviews.notfound"
    redirect_to root_path
  end

  private

  def load_tours
    if load_params_categoty_id.present? || load_price_min.present? || load_price_max.present?
      # @tours = Tour.sort_by_created_at
      #   .find_by_category_id(load_params_categoty_id)
      #   .find_max_price(load_price_min, load_price_max)
      #   .paginate page: params[:page],
      #   per_page: Settings.tour.length
      @tours = Tour.sort_by_created_at
        .find_by_category_id(load_params_categoty_id)
        .find_max_price(load_price_max)
        .find_min_price(load_price_min)
        .paginate page: params[:page],
        per_page: Settings.tour.length
    else
      @tours = Tour.sort_by_created_at.paginate page: params[:page],
        per_page: Settings.tour.length
    end
  end

  def load_price_min min = "0"
    return param = params[:category][:price_min] if params[:category].present?
  end

  def load_price_max max = "1000"
    return param = params[:category][:price_max] if params[:category].present?
  end

  def load_params_categoty_id
    return param = params[:category][:category_id] if params[:category].present?
  end
end
