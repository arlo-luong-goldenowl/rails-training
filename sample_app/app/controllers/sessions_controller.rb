class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    user = User.find_by(email: email)
    if(user && user.authenticate(password))
      log_in(user)
      flash[:success] = "Login successfully, Welcome to the Sample App!"
      redirect_to user
    else
      flash.now[:danger] = 'Invalid password'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

end
