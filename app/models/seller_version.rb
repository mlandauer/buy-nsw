class SellerVersion < ApplicationRecord
  include AASM
  extend Enumerize

  include Concerns::StateScopes
  include Concerns::Documentable

  include Discard::Model
  default_scope -> { kept }

  before_save :normalise_abn

  belongs_to :seller
  belongs_to :assigned_to, class_name: 'User', optional: true
  belongs_to :agreed_by, class_name: 'User', optional: true

  has_many :events, -> { order(created_at: :desc) }, as: :eventable, class_name: 'Event::Event'
  has_many :owners, through: :seller, class_name: 'User'

  has_documents :financial_statement, :professional_indemnity_certificate,
                :workers_compensation_certificate,
                :product_liability_certificate

  aasm column: :state do
    state :created, initial: true
    state :awaiting_assignment
    state :ready_for_review
    state :approved
    state :rejected

    event :submit do
      transitions from: :created, to: :awaiting_assignment, guard: :unassigned?
      transitions from: :created, to: :ready_for_review, guard: :assignee_present?

      before do
        self.submitted_at = Time.now
      end
    end

    event :assign do
      transitions from: :awaiting_assignment, to: :ready_for_review
    end

    event :approve do
      transitions from: :ready_for_review, to: :approved, guard: :no_approved_versions?

      after do
        seller.make_active!
        seller.products.each(&:make_active!)
      end
    end

    event :reject do
      transitions from: :ready_for_review, to: :rejected
    end

    event :return_to_applicant do
      transitions from: [:ready_for_review, :approved], to: :created
    end
  end

  def owners
    seller.owners
  end

  def assignee_present?
    assigned_to.present?
  end

  def unassigned?
    ! assignee_present?
  end

  def no_approved_versions?
    SellerVersion.approved.where(seller_id: seller_id).empty?
  end

  def addresses=(new_value)
    self[:addresses] = new_value.map(&:to_h)
  end

  def addresses
    Array(self[:addresses]).map {|value|
      SellerAddress.new(value)
    }
  end

  scope :for_review, -> { awaiting_assignment.or(ready_for_review) }

  scope :unassigned, -> { where('assigned_to_id IS NULL') }
  scope :assigned, -> { where('assigned_to_id IS NOT NULL') }
  scope :assigned_to, ->(user) { where('assigned_to_id = ?', user) }

  scope :disability, ->{ where(disability: true) }
  scope :indigenous, ->{ where(indigenous: true) }
  scope :not_for_profit, ->{ where(not_for_profit: true) }
  scope :regional, ->{ where(regional: true) }
  scope :sme, ->{ where(sme: true) }
  scope :start_up, ->{ where(start_up: true) }
  scope :govdc, ->{ where(govdc: true) }
  scope :with_service, ->(service){ where(":service = ANY(services)", service: service) }

  enumerize :number_of_employees, in: ['sole', '2to4', '5to19', '20to49', '50to99', '100to199', '200plus']
  enumerize :corporate_structure, in: ['standalone', 'subsidiary']
  enumerize :services, multiple: true, in: [
    'cloud-services',
    'software-development',
    'software-licensing',
    'end-user-computing',
    'infrastructure',
    'telecommunications',
    'managed-services',
    'advisory-consulting',
    'ict-workforce',
    'training-learning',
  ]

private
  def normalise_abn
    self.abn = ABN.new(abn).to_s if ABN.valid?(abn)
  end
end
