require 'rails_helper'

describe 'Merchants Search API' do

  it 'finds a single merchant which matches a search term' do
    create(:merchant, name: 'Badda Ring')
    create(:merchant, name: 'Turing School')
    create(:merchant, name: 'During School')

    get '/api/v1/merchants/find?name=ring'
    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(merchant[:data][:attributes][:name]).to eq('Badda Ring')
  end

  it 'returns an empty object if no merchant matches the search term' do
    create(:merchant, name: 'Badda Ring')
    create(:merchant, name: 'Turing School')
    create(:merchant, name: 'During School')

    get '/api/v1/merchants/find?name=blah'
    merchant = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(merchant[:data]).to eq({})
  end

  it 'finds all merchants which matches a search term' do
    create(:merchant, name: 'Badda Ring')
    create(:merchant, name: 'Turing School')
    create(:merchant, name: 'During School')

    get '/api/v1/merchants/find_all?name=ring'
    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(merchant[:data].count).to eq(3)
  end

  it 'returns a bad request error when query params include name with no value' do
    get '/api/v1/items/find_all?name='
    params = {
      name: ""
    }

    expect(CallSearch.search_merchant(params)).to eq(true)
    expect(response.status).to eq(400)
  end

  it 'returns a bad request error when there are no params given' do
    get '/api/v1/merchants/find_all?'

    expect(response.status).to eq(400)
  end
end