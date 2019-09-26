class UsersController < ApplicationController
  layout :resolve_layout

  before_action :logged_in_user, except: [:new, :create, :show]
  before_action :load_user, except: [:new, :create]
  before_action :correct_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new load_params
    if @user.save
      flash[:success] = t "controllers.signup.success"
      redirect_to root_path
    else
      flash[:fail] = t "controllers.signup.fail"
      render :new
    end
  end

  def show
    @reviews = @user.reviews.paginate page: params[:page],
      per_page: Settings.user.length.per_page
  end

  def edit; end

  def update
    if @user.update_attributes load_params
      flash[:success] = t "controllers.users.profiless"
      redirect_to @user
    else
      flash[:fail] = t "controllers.users.profilefail"
      render :edit
    end
  end

  private

  def load_params
    params.require(:user).permit :fullname, :email, :phone,
      :address, :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "controllers.users.danger"
    redirect_to login_url
  end

  def correct_user
    return if current_user? @user
    store_location
    flash[:danger] = t "controllers.users.danger"
    redirect_to login_url
  end
end

