class ProductOrder < ApplicationRecord
  belongs_to :buyer, class_name: 'BuyerApplication'
  belongs_to :product

  THRESHOLD = 150000

  scope :below_threshold, -> { where('estimated_contract_value < ?', THRESHOLD) }
  scope :above_threshold, -> { where('estimated_contract_value >= ?', THRESHOLD) }
end
