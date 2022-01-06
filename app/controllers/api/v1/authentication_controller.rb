module Api
    module V1
      class AuthenticationController < ApplicationController

        def create
            p params.inspect

            render json: { token: '123' }, status: :created
        end
        
      end
    end
end
