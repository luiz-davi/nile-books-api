require 'rails_helper'

describe 'Books API', type: :request do
    it 'returns all books' do
        FactoryBot.create(:book, title: 'O nome do Vento', author: "Patrick Rothfuss")
        FactoryBot.create(:book, title: 'Harry Potter', author: "JK Rooling")
        FactoryBot.create(:book, title: 'O Hobbit', author: "JRR Tolkien")
        FactoryBot.create(:book, title: 'O peregrino', author: "John Bunyan")
        
        get '/api/v1/books'

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(4)
    end
end