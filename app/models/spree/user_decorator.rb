Spree.user_class.class_eval do
  has_many :auth_tokens, class_name: 'SolidusJwt::Token'
  ##
  # Generate a json web token
  # @see https://github.com/jwt/ruby-jwt
  # @return [String]
  #
  def generate_jwt_token(expires_in: nil)
    SolidusJwt.encode(payload: as_jwt_payload, expires_in: expires_in)
  end
  alias generate_jwt generate_jwt_token

  private

  def as_jwt_payload
    as_json(only: %i[email id])
  end
end
