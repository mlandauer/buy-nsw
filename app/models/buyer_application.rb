require 'securerandom'

class BuyerApplication < ApplicationRecord
  include AASM
  extend Enumerize

  include Concerns::StateScopes

  belongs_to :assigned_to, class_name: 'User', optional: true
  belongs_to :user

  has_many :events, -> { order(created_at: :desc) }, as: :eventable, class_name: 'Event::Event'
  has_many :product_orders, foreign_key: :buyer_id

  enumerize :cloud_purchase, in: ['make-purchase', 'plan-purchase', 'no-plan']
  enumerize :contactable, in: ['phone-number', 'email', 'none']
  enumerize :employment_status, in: ['employee', 'contractor', 'other-eligible']

  aasm column: :state do
    state :created, initial: true
    state :awaiting_manager_approval
    state :awaiting_assignment
    state :ready_for_review
    state :approved
    state :rejected
    state :deactivated

    event :submit do
      transitions from: :created, to: :approved, guard: :no_approval_required?
      transitions from: :created, to: :awaiting_manager_approval, guard: :requires_manager_approval?

      transitions from: :created, to: :awaiting_assignment, guard: [:requires_email_approval?, :unassigned?]
      transitions from: :created, to: :ready_for_review, guard: [:requires_email_approval?, :assignee_present?]

      before do
        self.submitted_at = Time.now
      end
    end

    event :manager_approve do
      transitions from: :awaiting_manager_approval, to: :awaiting_assignment, guard: [:requires_email_approval?, :unassigned?]
      transitions from: :awaiting_manager_approval, to: :ready_for_review, guard: [:requires_email_approval?, :assignee_present?]
      transitions from: :awaiting_manager_approval, to: :approved
    end

    event :assign do
      transitions from: :awaiting_assignment, to: :ready_for_review
    end

    event :approve do
      transitions from: :ready_for_review, to: :approved
    end

    event :reject do
      transitions from: :ready_for_review, to: :rejected
    end

    event :deactivate do
      transitions from: :approved, to: :deactivated
    end
  end

  def requires_email_approval?
    # NOTE: once over, we were going to automatically whitelist buyers with a
    # `@nsw.gov.au` email address to avoid the need for manual review. However,
    # we dedided not to do this before launch, and hard-coded this to `true`.
    #
    # This should be safe to remove once the state machine transitions above
    # have been adjusted.
    #
    true
  end

  def no_approval_required?
    !requires_email_approval? && !requires_manager_approval?
  end

  def requires_manager_approval?
    employment_status == 'contractor'
  end

  def assignee_present?
    assigned_to.present?
  end

  def unassigned?
    ! assignee_present?
  end

  def self.find_by_user_and_application(user_id, application_id)
    where(user_id: user_id, id: application_id).first!
  end

  def set_manager_approval_token!
    update_attribute(:manager_approval_token, SecureRandom.hex(16))
  end

  def in_progress?
    created?
  end

  scope :assigned_to, ->(user) { where('assigned_to_id = ?', user) }
  scope :for_review, -> { awaiting_assignment.or(ready_for_review) }


end
