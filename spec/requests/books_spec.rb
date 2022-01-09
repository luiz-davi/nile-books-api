require 'rails_helper'

describe 'Books API', type: :request do
    let!(:first_author) {FactoryBot.create(:author, first_name: 'Patrick', last_name: "Rothfuss", age: 55)}
    let!(:second_author) {FactoryBot.create(:author, first_name: 'JK', last_name: "Rooling", age: 55)}

    describe 'GET /books' do
        before do
            FactoryBot.create(:book, title: 'O nome do Vento', author: first_author)
            FactoryBot.create(:book, title: 'Harry Potter', author: second_author)
        end
        it 'returns all books' do
            get '/api/v1/books'

            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(2)
            expect(response_body).to eq(
                [
                    {
                        "id"=> 1,
                        "title"=> "O nome do Vento",
                        "author_name"=> "Patrick Rothfuss",
                        "age"=> 55
                    },
                    {
                        "id"=> 2,
                        "title"=> "Harry Potter",
                        "author_name"=> "JK Rooling",
                        "age"=> 55
                    },
                ]
            )
        end

        it 'returns a subset of books based on limit' do
            get '/api/v1/books', params: { limit: 1 }

            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(1)
            expect(response_body).to eq(
                [
                    {
                        "id"=> 1,
                        "title"=> "O nome do Vento",
                        "author_name"=> "Patrick Rothfuss",
                        "age"=> 55
                    }
                ]
            )
        end

        it 'returns a subset of books based on limit and offset' do
            get '/api/v1/books', params: { limit: 1, offset: 1 }

            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(1)
            expect(response_body).to eq(
                [
                    {
                        "id"=> 2,
                        "title"=> "Harry Potter",
                        "author_name"=> "JK Rooling",
                        "age"=> 55
                    }
                ]
            )
        end

        it 'has a max limit of 100' do
            expect(Book).to receive(:limit).with(100).and_call_original

            get '/api/v1/books', params: { limit: 999 }
        end
    end

    describe 'POST /books' do
        it 'create a new book' do
            expect {
                post '/api/v1/books', params: {
                    author: {first_name: "Patrick", last_name: "Rothfuss", age: 40},
                    book: {title: 'O temor do sábio'}
                }, headers: { "Authorization" => "Bearer 123" }
            }.to change { Book.count }.from(0).to eq(1)
            
            expect(response).to have_http_status(:created)
            expect(Author.count).to eq(3)
            expect(response_body).to eq(
                {
                    "id"=> 1,
                    "title"=> "O temor do sábio",
                    "author_name"=> "Patrick Rothfuss",
                    "age"=> 40
                }
            )
        end
    end

    describe 'DELETE /books/:id' do
        let!(:book) {FactoryBot.create(:book, title: 'O nome do Vento', author: first_author)}
        it 'deletes a book' do
            expect{
                delete "/api/v1/books/#{book.id}"
            }.to change { Book.count }.from(1).to(0)
            
            expect(response).to have_http_status(:no_content)
        end
    end
end