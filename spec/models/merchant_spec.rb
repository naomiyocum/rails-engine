# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { is_expected.to have_many(:items) }
  end

  describe 'class methods' do
    describe '.find_one_name' do
      it 'returns the first object in case-insensitive alphabetical order if multiple matches are found' do
        merch_1 = create(:merchant, name: 'Badda Ring')
        merch_2 = create(:merchant, name: 'Turing School')
        merch_3 = create(:merchant, name: 'During School')

        expect(Merchant.find_all('ring')).to eq([merch_1, merch_2, merch_3])
      end
    end
  end
end
