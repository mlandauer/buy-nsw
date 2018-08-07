module Sellers::SellerVersion::Contract
  class Recognition < Base

    AccreditationPrepopulator = ->(_) {
      self.accreditations ||= []

      count = 0
      while (self.accreditations.size < 10 && count < 2)
        self.accreditations << ''
        count += 1
      end
    }

    AwardPrepopulator = ->(_) {
      self.awards ||= []

      count = 0
      while (self.awards.size < 10 && count < 2)
        self.awards << ''
        count += 1
      end
    }

    EngagementPrepopulator = ->(_) {
      self.engagements ||= []

      count = 0
      while (self.engagements.size < 10 && count < 2)
        self.engagements << ''
        count += 1
      end
    }

    def accreditations=(array)
      super(filter_blank_values(array))
    end

    def awards=(array)
      super(filter_blank_values(array))
    end

    def engagements=(array)
      super(filter_blank_values(array))
    end

    def filter_blank_values(array)
      Array(array).reject{|row|
        row.gsub(/\s/,'').blank?
      }
    end

    collection :accreditations, prepopulator: AccreditationPrepopulator
    collection :awards, prepopulator: AwardPrepopulator
    collection :engagements, prepopulator: EngagementPrepopulator

    validation :default, inherit: true do
      required(:accreditations).value(max_items?: 10)
      required(:awards).value(max_items?: 10)
      required(:engagements).value(max_items?: 10)
    end
  end
end
