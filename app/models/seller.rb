class Seller < ApplicationRecord
  include AASM
  extend Enumerize

  include Concerns::Documentable
  include Concerns::StateScopes

  include Discard::Model
  default_scope -> { kept } # rubocop:disable Airbnb/DefaultScope

  has_many :owners, class_name: 'User'
  belongs_to :agreed_by, class_name: 'User', optional: true

  has_one :waiting_seller
  has_many :products

  has_many :versions, class_name: 'SellerVersion'
  has_one :approved_version, -> { approved }, class_name: 'SellerVersion'
  has_one :first_version, -> { where(previous_version: nil) }, class_name: 'SellerVersion'
  has_one :last_version, -> { order started_at: :desc }, class_name: 'SellerVersion'

  aasm column: :state do
    state :inactive, initial: true
    state :active

    event :make_active do
      transitions from: :inactive, to: :active
    end

    event :make_inactive do
      transitions from: :active, to: :inactive
    end
  end

  def version_in_progress?
    versions.created.any?
  end

  def approved_name
    approved_version&.name
  end

  after_discard do
    products.discard_all
    versions.discard_all
    owners.discard_all
  end
end
