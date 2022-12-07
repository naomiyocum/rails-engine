class Merchant < ApplicationRecord
  has_many :items

  def self.find_all(name)
    where("name ILIKE ?", "%#{name}%")
  end
end
