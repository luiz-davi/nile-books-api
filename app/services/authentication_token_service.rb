class AuthenticationTokenService
    HMAC_SECRET = 'my$ecretK3y'
    ALGORITHM_TYPE = 'HS256'
    def self.call
        payload = { "test" => "blá" }

        token = JWT.encode payload, HMAC_SECRET, ALGORITHM_TYPE
    end
end