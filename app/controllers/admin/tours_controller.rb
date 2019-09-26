class Admin::ToursController < ApplicationController
  layout "layouts/admin"

  before_action :admin_is_loggin?
  before_action :is_admin?
  before_action :load_tour, only: :destroy

  def index
    @categorys = Category.all
    @tours = Tour.all
    @tour = Tour.new
  end

  def create
    @tour = Tour.new(load_params)
    load_date_in_for_tour
    load_date_out_for_tour
    ActiveRecord::Base.transaction do
      @tour.save!
      @images = params[:tour][:images]
      if @images.present?
        save_picture
      end
      flash[:success] = "succcess"
      redirect_to request.referrer
    end
  rescue
    flash[:danger] = "create fail"
    redirect_to request.referrer
  end

  def destroy
    if @tour.destroy
      flash[:success] = "Xoa Thanh Cong"
      redirect_to request.referrer
    else
      flash[:danger] = "Xoa Khong Thanh Cong"
      redirect_to request.referrer
    end
  end

  private

  def load_params
    params.require(:tour).permit :name, :price, :place, :image, :food, :category_id
  end

  def load_tour
    @tour = Tour.find_by id: params[:id]
  end

  def save_picture
    @images.each do |image|
      tour_image = @tour.imagerelations.build(user: current_user, picture: image)
      tour_image.save
    end
  end

  def load_date_in_for_tour
    dayIn = params[:tour][:"startdate(3i)"]
    monthIn = params[:tour][:"startdate(2i)"]
    yearIn = params[:tour][:"startdate(1i)"]
    departureTimeIn = params[:departure_time]
    @tour.startdate = Time.new(yearIn, monthIn, dayIn,
      departureTimeIn).to_formatted_s(:db)
  end

  def load_date_out_for_tour
    dayOut = params[:tour][:"startdate(3i)"]
    monthOut = params[:tour][:"startdate(2i)"]
    yearOut = params[:tour][:"startdate(1i)"]
    departureTimeOut = params[:end_time]
    @tour.finishdate = Time.new(yearOut, monthOut ,dayOut,
      departureTimeOut).to_formatted_s(:db)
  end
end
