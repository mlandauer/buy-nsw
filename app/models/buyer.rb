class Buyer < ApplicationRecord
  include AASM
  include Concerns::StateScopes

  ALIAS_FIELDS = [:name, :organisation, :employment_status, :user_id]

  ALIAS_FIELDS.each do |field|
    define_method(field) do |*args, &block|
      applications.first&.send(field, *args, &block)
    end
  end

  belongs_to :user
  has_many :applications, class_name: 'BuyerApplication'
  has_many :product_orders

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

  def application_in_progress?
    applications.created.any?
  end

  def recent_application
    applications.last
  end
end
