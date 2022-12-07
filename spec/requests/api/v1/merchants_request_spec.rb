require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 5)

    get api_v1_merchants_path
    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(merchants).to be_a(Hash)
    expect(merchants[:data].count).to eq(5)
    expect(merchants[:data]).to be_an(Array)
    
    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'can get one merchant by id' do
    id = create(:merchant).id

    get api_v1_merchant_path(id)
    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_a(String)

    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data][:type]).to be_a(String)

    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes]).to be_a(Hash)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

  it 'returns a 404 status if no merchant is found' do
    id = create(:merchant, id: 3).id

    get api_v1_merchant_path(2)

    expect(response.status).to eq(404)
  end

  it 'can get all items under a specific merchant id' do
    id_check = create(:merchant).id
    id_rando = create(:merchant).id

    create_list(:item, 3, merchant_id: id_check)
    create_list(:item, 7, merchant_id: id_rando)
    
    get api_v1_merchant_items_path(id_check)

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(items[:data].count).to eq(3)
  end

  it 'returns a 404 status if merchant does not exist' do
    id_check = create(:merchant, id: 1).id

    create_list(:item, 7, merchant_id: id_check)
    
    get api_v1_merchant_items_path(2)

    expect(response.status).to eq(404)
  end

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

  it 'returns an empty data array if no merchant matches the search term' do
    create(:merchant, name: 'Badda Ring')
    create(:merchant, name: 'Turing School')
    create(:merchant, name: 'During School')

    get '/api/v1/merchants/find?name=blah'
    merchant = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(merchant[:data]).to eq([])
  end
end