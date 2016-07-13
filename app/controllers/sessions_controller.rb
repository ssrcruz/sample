class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase) # params hash has all the info to authenticate email and password
    if user && user.authenticate(params[:session][:password]) # checks if the user info input is the same as in the database.
      log_in user
      remember user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user) # uses binary values 0 and 1, or yes and no. checks to remember the user or forget the user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
