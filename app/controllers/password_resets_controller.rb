class PasswordResetsController < ApplicationController
  before_action :get_user,      only: [:edit, :update]
  before_action :valid_user,    only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Our gnomes have crafted you a password reset link. Check your email"
      redirect_to root_url
    else
      flash.now[:danger] = "We couldn't find that email address"
      render 'new'
    end
  end

  def edit
    debugger
  end

  def update
    if params[:user][:password].empty?
      flash.now[:danger] = "Gotta put in a password :)"
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Our gnomes have carved your password in stone in our mountain."
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # Before fileters
    
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirm valid user
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # Check to make sure reset token hasn't expired
    def check_expiration
      debugger
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
