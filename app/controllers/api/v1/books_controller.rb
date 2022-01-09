require 'net/http'

module Api
  module V1
    class BooksController < ApplicationController
      include ActionController::HttpAuthentication::Token

      MAX_PAGINATION_LIMIT = 100

      before_action :authenticate_user, only: %i[:create, :desstroy]

      def index
        books = Book.limit(limit).offset(params[:offset])

        render json: BooksRepresenter.new(books).as_json
      end

      def create
        author = Author.create(author_params)
        book = Book.new(book_params.merge(author_id: author.id))

        UpdateSkuJob.perform_later(book_params[:title])

        if book.save
          render json:  BookRepresenter.new(book).as_json, status: :created
        else
          render json:  BookRepresenter.new(book).as_json, status: :unprocessable_entity
        end
      end

      def destroy
        Book.find(params[:id]).destroy!

        head :no_content
      end

      private 
    
        def authenticate_user
          # Authorization: Bearer <token>
          token, options = token_and_options(request)

          raise token.inspect

          user_id = AuthenticationTokenService.decode_token(token)
        
          User.find(user_id)
        rescue ActiveRecord::RecordNotFound
          render status: :unauthorized
        end

        def author_params
          params.require(:author).permit(:first_name, :last_name, :age)
        end

        def book_params
          params.require(:book).permit(:title)
        end

        def limit
          [
            params.fetch(:limit, MAX_PAGINATION_LIMIT ).to_i,
            MAX_PAGINATION_LIMIT  
          ].min
        end
    end
  end
end
