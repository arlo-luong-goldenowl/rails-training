class UsersController < ApplicationController
  def new
    if current_user
      puts " CURRENT "
      flash[:warning] = "Already logged"
      redirect_to '/profile'
    else
      puts " KHONG CO"
      @user = User.new
    end
  end

  # def show
    # @user = User.find(params[:id])
  # end

  def profile
    @user = User.find(current_user.id)
    render 'show'
  end

  def create
    @user = User.new(user_params)    # Not the final implementation!
    @user.password_digest = User.digest(user_params[:password])
    if @user.save
      log_in(@user)
      flash[:success] = "Create account successfully, Welcome to the Sample App!"
      redirect_to '/profile'
    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
