require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:merchant) }
    it { is_expected.to have_many(:invoice_items)}
    it { is_expected.to have_many(:invoices).through(:invoice_items)}
    it { is_expected.to have_many(:transactions).through(:invoices)}
  end

  describe 'class methods' do
    describe '.find_all_name' do
      it 'returns the first object in case-insensitive alphabetical order if multiple matches are found' do
        item_1 = create(:item, name: 'Badda Ring')
        item_2 = create(:item, name: 'Turing School')
        item_3 = create(:item, name: 'During School')
        item_4 = create(:item, name: 'nope')

        expect(Item.find_all_name('ring')).to eq([item_1, item_2, item_3])
      end
    end

    describe '.find_all_min' do
      it 'returns all items that are priced equal to or greater than the min price' do
        item_1 = create(:item, unit_price: 99.99)
        item_2 = create(:item, unit_price: 20)
        item_3 = create(:item, unit_price: 2)
        item_4 = create(:item, unit_price: 0.99)

        expect(Item.find_all_min(4.55)).to eq([item_1, item_2])
        expect(Item.find_all_min(100)).to eq([])
      end
    end

    describe '.find_all_max' do
      it 'returns all items that are priced equal to or less than the max price' do
        item_1 = create(:item, unit_price: 99.99)
        item_2 = create(:item, unit_price: 20)
        item_3 = create(:item, unit_price: 2)
        item_4 = create(:item, unit_price: 0.99)

        expect(Item.find_all_max(99.99)).to eq([item_1, item_2, item_3, item_4])
        expect(Item.find_all_max(1)).to eq([item_4])
      end
    end

    describe '.find_all_range' do
      it 'returns all items that are priced within the range given' do
        item_1 = create(:item, unit_price: 99.99)
        item_2 = create(:item, unit_price: 20)
        item_3 = create(:item, unit_price: 2)
        item_4 = create(:item, unit_price: 0.99)

        expect(Item.find_all_range(20, 25)).to eq([item_2])
        expect(Item.find_all_range(0, 5)).to eq([item_3, item_4])
      end
    end
  end
end
