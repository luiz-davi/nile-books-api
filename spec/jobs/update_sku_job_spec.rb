require 'rails_helper'
require 'net/http'

RSpec.describe UpdateSkuJob, type: :job do
  let!(:book_title) { 'O nome do vento' }

  before do
    allow(Net::HTTP).to receive(:start).and_return(true)
  end

  it 'calls SKU service with carrect params' do
    expect_any_instance_of(Net::HTTP::Post).to receive(:body=).with(
      {sku: '123', name: book_title}.to_json
    )

    described_class.perform_now(book_title)
  end
end
