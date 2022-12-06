require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it {is_expected.to belong_to(:customer)}
    it {is_expected.to have_many(:transactions)}
    it {is_expected.to have_many(:invoice_items)}
    it {is_expected.to have_many(:items).through(:invoice_items)}
  end

  describe 'instance methods' do
    describe '#destroy_empty' do
      it 'destroys an invoice if there are no items on it' do
        merchant = create(:merchant)
        customer = create(:customer)
        item_1 = create(:item, merchant_id: merchant.id)
        item_2 = create(:item, merchant_id: merchant.id)
        invoice_1 = create(:invoice, merchant_id: merchant.id, customer_id: customer.id)
        invoice_2 = create(:invoice, merchant_id: merchant.id, customer_id: customer.id)
        invoice_3 = create(:invoice, merchant_id: merchant.id, customer_id: customer.id)
        create(:invoice_item, invoice_id: invoice_1.id, item_id: item_1.id)
        create(:invoice_item, invoice_id: invoice_1.id, item_id: item_2.id)
        create(:invoice_item, invoice_id: invoice_2.id, item_id: item_1.id)
        create(:invoice_item, invoice_id: invoice_2.id, item_id: item_2.id)
        create(:invoice_item, invoice_id: invoice_3.id, item_id: item_1.id)

        expect(Invoice.count).to eq(3)

        Item.destroy(item_1.id)
        Invoice.all.map {|invoice| invoice.destroy_empty}
        expect(Invoice.count).to eq(2)
      end
    end
  end
end