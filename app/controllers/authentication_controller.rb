class AuthenticationController < ApplicationController
  skip_before_action :authenticate, only: [:login]

  def login
    @user = User.find_by(username: params[:username])
    if @user
      if @user.authenticate(params[:password])   # ??
        payload = { user_id: @user.id }   # ??
        secret = ENV['SECRET_KEY_BASE'] || Rails.application.secret_key_base   # ??
        token = create_token(payload)  # ??
        render json:
                 {
                   usertoken: token,
                 }
      else
        render json: { massage: "Authentication Failed" }
      end
    else
      render json: { massage: "Could not find user" }
    end
  end

end
