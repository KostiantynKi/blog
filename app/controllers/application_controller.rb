class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session # ??

  before_action :check_user
  before_action :authenticate


  def check_user
    if request.headers["Authorization"]
      begin
        auth_header = request.headers["Authorization"] # ??
        decoded_token = JWT.decode(auth_header, secret)
        puts ("DECODED = #{decoded_token}")
        payload = decoded_token.first # ??
        user_id = payload["user_id"] # ??
        @user = User.find(user_id)
      rescue => exception # ??
        render json: { massage: "Error: #{exception}" }, status: :forbidden
      end
    end
  end

    def authenticate
      if @user.nil?
        puts ("USER is #{@user}")
        render json: { massage: "No Authorization user" }, status: :unauthorized
      end
    end

    def secret
      secret = ENV['SECRET_KEY_BASE'] || Rails.application.secret_key_base
    end

    def token
      auth_header.split(" ")[1]
    end

    def create_token(payload)
      JWT.encode(payload, secret)
    end

  end

  '' ' old version:

  before_action :authenticate

def authenticate
  if request.headers["Authorization"]
    begin
      auth_header = request.headers["Authorization"] # ??
      decoded_token = JWT.decode(auth_header, secret)
      puts ("DECODED = #{decoded_token}")
      payload = decoded_token.first # ??
      user_id = payload["user_id"] # ??
      @user = User.find(user_id)
    rescue => exception # ??
      render json: { massage: "Error: #{exception}" }, status: :forbidden
    end
  else
    render json: { massage: "No Authorization header sent" }, status: :forbidden
  end
end
' ''