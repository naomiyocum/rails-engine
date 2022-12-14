# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  def destroy_empty
    Invoice.destroy(id) if items.empty?
  end
end
