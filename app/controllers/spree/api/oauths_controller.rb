module Spree
  module Api
    class OauthsController < BaseController
      skip_before_action :authenticate_user

      def token
        if user = try_authenticate_user
          render_token_for(user)
        else
          render status: 401, json: { error: 'invalid username or password' }
        end
      end

      private

      def render_token_for(user)
        render json: {
          access_token: user.generate_jwt,
          refresh_token: generate_refresh_token_for(user)
        }
      end

      def try_authenticate_user
        warden.authenticate(:solidus_jwt_password) ||
          warden.authenticate(:solidus_jwt_refresh_token)
      end

      def generate_refresh_token_for(user)
        token_resource = user.auth_tokens.create!
        token_resource.token
      end
    end
  end
end
