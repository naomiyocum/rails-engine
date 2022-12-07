require 'rails_helper'

describe 'Items API' do
  it 'sends a list of items' do
    create_list(:item, 5)

    get api_v1_items_path
    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(items).to be_a(Hash)
    expect(items[:data].count).to eq(5)
    expect(items[:data]).to be_an(Array)
    
    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to be_a(String)

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  it 'can get one item by id' do
    id = create(:item).id

    get api_v1_item_path(id)
    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)

    expect(item[:data]).to have_key(:type)
    expect(item[:data][:type]).to be_a(String)

    attributes = item[:data][:attributes]
    expect(item[:data]).to have_key(:attributes)
    expect(attributes).to be_a(Hash)

    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a(String)

    expect(attributes).to have_key(:description)
    expect(attributes[:description]).to be_a(String)

    expect(attributes).to have_key(:unit_price)
    expect(attributes[:unit_price]).to be_a(Float)

    expect(attributes).to have_key(:merchant_id)
    expect(attributes[:merchant_id]).to be_an(Integer)
  end

  it 'returns a 404 status if no item is found' do
    id = create(:item, id: 3).id

    get api_v1_item_path(2)

    expect(response.status).to eq(404)
  end

  it 'can create a new item' do
    id = create(:merchant).id
    item_params = ({
      name: 'Mesh Shorts',
      description: 'Super comfy',
      unit_price: 19.99,
      merchant_id: id
    })
    headers = {"CONTENT_TYPE" => "application/json"}

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last
   
    expect(response).to be_successful
    expect(response.status).to eq(201)
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'can update an existing item' do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: 'Fish Sauce' }
    headers = { "CONTENT_TYPE" => "application/json" }

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq('Fish Sauce')
  end

  it 'can update an existing item with a found merchant' do
    merch = create(:merchant, id: 1)
    id = create(:item, merchant_id: merch.id).id
    previous_name = Item.last.name
    item_params = {
      name: 'Fish Sauce',
      merchant_id: 1
    }
    headers = { "CONTENT_TYPE" => "application/json" }

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq('Fish Sauce')
  end

  it 'returns a 404 status if no merchant is found when updating an item' do
    merch_id = create(:merchant, id: 1).id
    id = create(:item, merchant_id: merch_id).id
    item_params = ({
      name: 'Mesh Shorts',
      description: 'Super comfy',
      unit_price: 19.99,
      merchant_id: 2
    })
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})

    expect(response.status).to eq(404)
  end

  it 'can delete an item' do
    item = create(:item)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(response.status).to eq(204)
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'deletes the invoice associated with the deleted item if it was the only item on invoice' do
    merchant = create(:merchant)
    customer = create(:customer)
    item = create(:item, merchant_id: merchant.id)
    invoice = create(:invoice, merchant_id: merchant.id, customer_id: customer.id)
    create(:invoice_item, invoice_id: invoice.id, item_id: item.id)

    expect(Invoice.count).to eq(1)
    expect(invoice.items.count).to eq(1)
    expect(invoice.present?).to eq(true)

    delete "/api/v1/items/#{item.id}"
    
    expect(response).to be_successful
    expect(response.status).to eq(204)
    expect(invoice.items.count).to eq(0)
    expect(Invoice.count).to eq(0)
  end

  it 'can return the merchant associated with the item' do
    id = create(:merchant).id
    item = create(:item, merchant_id: id)
    
    get "/api/v1/items/#{item.id}/merchant"
    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(merchant[:data][:id]).to eq(id.to_s)
  end

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
end