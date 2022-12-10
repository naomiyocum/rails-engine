# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:invoice) }
  end
end
