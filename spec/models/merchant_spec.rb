require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { is_expected.to have_many(:items) }
  end
end
