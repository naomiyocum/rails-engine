class Merchant < ApplicationRecord
  has_many :items

  def self.find_one_name(name)
    where("name ILIKE ?", "%#{name}%").first
  end
end
