# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'relationships' do
    it { is_expected.to have_many(:invoices) }
    it { is_expected.to have_many(:transactions).through(:invoices) }
  end
end
