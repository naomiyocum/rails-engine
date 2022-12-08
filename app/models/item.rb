class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  def self.find_all_name(name)
    where("name ILIKE ?", "%#{name}%")
  end

  def self.find_all_min(price)
    where("unit_price >= ?", price).order(:name)
  end

  def self.find_all_max(price)
    where("unit_price <= ?", price).order(:name)
  end

  def self.find_all_range(min, max)
    where(unit_price: min.to_f..max.to_f)
  end
end
