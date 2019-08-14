class SessionsController < ApplicationController
  def new
    if current_user
      flash[:warning] = "Already logged"
      redirect_to current_user
    end
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    user = User.find_by(email: email)
    if(user && user.authenticate(password))
      log_in(user)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:success] = "Login successfully, Welcome to the Sample App!"
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid password'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
