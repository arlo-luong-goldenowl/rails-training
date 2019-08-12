class UsersController < ApplicationController
  def new
    if current_user
      flash[:warning] = "Already logged"
      redirect_to current_user
    else
      @user = User.new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)    # Not the final implementation!
    @user.password_digest = User.digest(user_params[:password])
    if @user.save
      log_in(@user)
      flash[:success] = "Create account successfully, Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
