class BookingtoursController < ApplicationController
  layout :resolve_layout, only: :show

  before_action :logged_in_user
  before_action :load_tour, only: [:create, :new]
  before_action :check_amountpeople_bookingtour? , only: :create
  before_action :check_tour_full?, only: :new
  before_action :load_booking, :correct_user_for_booking, only: :destroy

  def new
    @bookingtour = @tour.booking_tours.build
  end

  def show
    @bookingtours = current_user.booking_tours.sort_by_created_at.paginate page: params[:page],
      per_page: Settings.user.length.per_page
  end

  def create
    ActiveRecord::Base.transaction do
      @bookingtour.save
      subtraction_qty
      flash[:success] = t "controllers.bookingtours.create.success"
      redirect_to root_path
    rescue StandardError
      flash[:danger] = t "controllers.bookingtours.create.danger"
      redirect_to request.referrer || root_url
    end
  end

  def destroy
    if @bookingtour.start?
      ActiveRecord::Base.transaction do
        @bookingtour.destroy
        update_amountpeople_for_tour
        flash[:success] = t "controllers.bookingtours.destroy.success"
      rescue StandardError
        flash[:danger] = t "controllers.bookingtours.destroy.danger"
      end
      redirect_to request.referrer
    else
      flash[:danger] = t "controllers.bookingtours.destroy.warn"
      redirect_to request.referrer || root_url
    end
  end

  private

  def load_tour
    @tour = Tour.find_by id: params[:tour_id]
    return if @tour
    flash[:danger] = t "controllers.bookingtours.load_tour.danger"
    redirect_to root_path
  end

  def bookingtour_params
    params.require(:booking_tour).permit :name, :phone, :address,
      :amountpeople, :tour_id
  end

  def subtraction_qty
    quantity = @tour.amountpeople - @bookingtour.amountpeople
    @tour.update_attributes amountpeople: quantity
  end

  def check_amountpeople_bookingtour?
    @bookingtour = current_user.booking_tours.build(bookingtour_params)
    amountpeople = @bookingtour.amountpeople
    @tour.amountpeople - amountpeople >= Settings.full
  end

  def update_amountpeople_for_tour
    @tour = Tour.find_by id: @bookingtour.tour_id
    dem = @tour.amountpeople + @bookingtour.amountpeople
    @tour.update_attributes amountpeople: dem
    return if @tour
    flash[:danger] = "Tour not exist"
    redirect_to root_path
  end

  def check_tour_full?
    return if @tour.amountpeople > Settings.full
    flash[:danger] = t "controllers.bookingtours.check_tour_full?.danger"
    redirect_to request.referrer || root_path
  end

  def load_booking
    @bookingtour = BookingTour.find_by id: params[:bookingtour_id]
    return if @bookingtour
    flash[:danger] = t "controllers.bookingtours.load_booking.danger"
    redirect_to root_path
  end

  def correct_user_for_booking
    @user = @bookingtour.user
    return if current_user? @user
    flash[:danger] = t "controllers.bookingtours.correct_user_for_booking.d"
    redirect_to request.referrer || root_url
  end
end
