require 'rails_helper'

describe 'Items Search API' do

  it 'finds all items matching a search term' do
    create(:item, name: 'Dog toy')
    create(:item, name: 'dog house')
    create(:item, name: 'shirt')
    create(:item, name: 'doggo')

    get '/api/v1/items/find_all?name=dog'
    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(items[:data].count).to eq(3)
  end

  it 'finds all items that are priced equal to or greater than the min_price' do
    create(:item, unit_price: 3.99)
    create(:item, unit_price: 2.99)
    create(:item, unit_price: 1.99)
    create(:item, unit_price: 0.99)

    get '/api/v1/items/find_all?min_price=2.00'
    items = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(items[:data].count).to eq(2)
  end

  it 'finds all items that are priced equal to or less than the max_price' do
    create(:item, unit_price: 3.99)
    create(:item, unit_price: 2.99)
    create(:item, unit_price: 1.99)
    create(:item, unit_price: 0.99)

    get '/api/v1/items/find_all?max_price=2.99'
    items = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(items[:data].count).to eq(3)
  end

  it 'finds all items that are priced within a range' do
    create(:item, unit_price: 3.99)
    create(:item, unit_price: 2.99)
    create(:item, unit_price: 1.99)
    create(:item, unit_price: 0.99)

    get '/api/v1/items/find_all?max_price=2.99&min_price=1.99'
    items = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(items[:data].count).to eq(2)
  end

  it 'returns an empty data array if no item matches the search term' do
    create(:item, name: 'Dog toy')
    create(:item, name: 'dog house')
    create(:item, name: 'shirt')
    create(:item, name: 'doggo')

    get '/api/v1/items/find_all?name=hello'
    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(items[:data]).to eq([])
  end

  it 'returns a bad request error when query params for min_price are less than 0' do
    get '/api/v1/items/find_all?min_price=-100'

    expect(response.status).to eq(400)
  end

  it 'returns a bad request error when query params for max_price are less than 0' do
    get '/api/v1/items/find_all?max_price=-100'

    expect(response.status).to eq(400)
  end

  it 'returns a bad request error when query params include name and min_price' do
    get '/api/v1/items/find_all?min_price=5&&name=ring'

    expect(response.status).to eq(400)
  end

  it 'returns a bad request error when query params include name and max_price' do
    get '/api/v1/items/find_all?max_price=5&&name=ring'

    expect(response.status).to eq(400)
  end

  it 'returns a bad request error when query params include name with no value' do
    get '/api/v1/items/find_all?name='

    expect(response.status).to eq(400)
  end

  it 'returns a bad request error when there are no params given' do
    get '/api/v1/items/find_all?'

    expect(response.status).to eq(400)
  end

  it 'returns a bad request error when max price is empty' do
    get '/api/v1/items/find?max_price='

    expect(response.status).to eq(400)
  end

  it 'returns a bad request error when min price is empty' do
    get '/api/v1/items/find?min_price='

    expect(response.status).to eq(400)
  end

  it 'returns a bad request error if min price is higher than max price' do
    get '/api/v1/items/find?min_price=100&max_price=3'

    expect(response.status).to eq(400)
  end

  it 'finds one item matching a search term' do
    create(:item, name: 'Dog toy')
    create(:item, name: 'dog house')
    create(:item, name: 'shirt')
    create(:item, name: 'doggo')

    get '/api/v1/items/find?name=dog'
    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(items[:data][:attributes][:name]).to eq('Dog toy')
  end

  it 'finds one item that is priced equal to or greater than the min_price' do
    create(:item, unit_price: 3.99)
    create(:item, unit_price: 2.99)
    create(:item, unit_price: 1.99)
    create(:item, unit_price: 0.99)

    get '/api/v1/items/find?min_price=3.00'
    items = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(items[:data][:attributes][:unit_price]).to eq(3.99)
  end

  it 'finds an item that is priced equal to or less than the max_price' do
    create(:item, unit_price: 3.99)
    create(:item, unit_price: 2.99)
    create(:item, unit_price: 1.99)
    create(:item, unit_price: 0.99)

    get '/api/v1/items/find?max_price=1.00'
    items = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(items[:data][:attributes][:unit_price]).to eq(0.99)
  end

  it 'finds an item that is priced within a range' do
    create(:item, unit_price: 3.99)
    create(:item, unit_price: 2.99)
    create(:item, unit_price: 1.99)
    create(:item, unit_price: 0.99)

    get '/api/v1/items/find?max_price=3.00&min_price=2.50'
    items = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(items[:data][:attributes][:unit_price]).to eq(2.99)
  end
end