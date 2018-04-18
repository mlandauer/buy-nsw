module Sellers::SellerApplication::Contract
  class Recognition < Base
    AccreditationPopulator = -> (options) {
      return NestedChildPopulator.call(options.merge(
        params: [:accreditation],
        model_klass: SellerAccreditation,
        context: self,
      ))
    }

    AwardPopulator = -> (options) {
      return NestedChildPopulator.call(options.merge(
        params: [:award],
        model_klass: SellerAward,
        context: self,
      ))
    }

    EngagementPopulator = -> (options) {
      return NestedChildPopulator.call(options.merge(
        params: [:engagement],
        model_klass: SellerEngagement,
        context: self,
      ))
    }

    AccreditationPrepopulator = ->(_) {
      2.times do
        self.accreditations << SellerAccreditation.new(seller_id: seller_id)
      end
    }

    AwardPrepopulator = ->(_) {
      2.times do
        self.awards << SellerAward.new(seller_id: seller_id)
      end
    }

    EngagementPrepopulator = ->(_) {
      2.times do
        self.engagements << SellerEngagement.new(seller_id: seller_id)
      end
    }

    collection :accreditations, on: :seller, prepopulator: AccreditationPrepopulator, populator: AccreditationPopulator do
      property :accreditation
    end

    collection :awards, on: :seller, prepopulator: AwardPrepopulator, populator: AwardPopulator do
      property :award
    end

    collection :engagements, on: :seller, prepopulator: EngagementPrepopulator, populator: EngagementPopulator do
      property :engagement
    end
  end
end
