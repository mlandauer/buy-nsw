module BuyerApplications
  class TermsForm < BaseForm
    def valid?
      true
    end

    def started?
      false
    end
  end
end
