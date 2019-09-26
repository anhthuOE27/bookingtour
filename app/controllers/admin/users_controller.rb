class Admin::UsersController < ApplicationController
  layout "layouts/admin"

  before_action :admin_is_loggin?
  before_action :is_admin?
  before_action :load_user, only: [:destroy, :update]

  def index
    @roles = User.select(:role).map(&:role).uniq
    @users = User.all
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controllers.signup.success"
      redirect_to request.referrer
    else
      flash[:fail] = t "controllers.signup.fail"
      redirect_to request.referrer
    end
  end

  def search
    @users = User.search_user_by_name(params[:name])
    cover_json
    respond_to do |format|
      format.json do
        render json: cover_json
      end
    end
  end

  def update
    user = User.find_by id: params[:user_id]
    if current_user == user
      flash[:danger] = "Can't change yourself"
      redirect_to request.referrer
    else
      user.update_attributes role: params[:role]
      redirect_to request.referrer
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
  end

  def cover_json
    @result = {}
    @users.map do |user|
      @result[:"#{user}"] = User.as_json user
    end
    @result
  end

  def conver_roles_to_json
    @roles = User.select(:role).map(&:role).uniq
    @role = {}
    @roles.map {|role| @role[:"#{role}"] = role}
  end
end
