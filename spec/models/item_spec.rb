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
  end
end
