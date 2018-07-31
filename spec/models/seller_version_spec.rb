require 'rails_helper'

RSpec.describe SellerVersion do

  describe "#abn" do
    it "should normalise a valid value" do
      seller = create(:approved_seller_version, abn: "24138089942")
      expect(seller.abn).to eq("24 138 089 942")
    end

    it "should do nothing to an already normalised value" do
      seller = create(:approved_seller_version, abn: "24 138 089 942")
      expect(seller.abn).to eq("24 138 089 942")
    end

    it "should not normalise an invalid value" do
      seller = create(:approved_seller_version, abn: "1234")
      expect(seller.abn).to eq("1234")
    end

    # This is actually testing the factory
    it "should create consecutive valid ABNs" do
      seller1 = build(:approved_seller_version)
      seller2 = build(:approved_seller_version)
      seller3 = build(:approved_seller_version)
      expect(ABN.valid?(seller1.abn)).to be_truthy
      expect(ABN.valid?(seller2.abn)).to be_truthy
      expect(ABN.valid?(seller3.abn)).to be_truthy
    end
  end

  describe '#approve' do
    subject { create(:ready_for_review_seller_version, seller: version.seller) }

    context 'when there are no "approved" versions for the same seller' do
      let(:version) { create(:created_seller_version) }

      it 'can be approved' do
        expect(subject.may_approve?).to be_truthy
      end

      it 'makes the seller active' do
        subject.approve
        expect(subject.seller.reload).to be_active
      end

      it 'approves the seller products' do
        products = create_list(:inactive_product, 3, seller: subject.seller)

        subject.approve
        products.each(&:reload)

        expect(products.select(&:active?).size).to eq(3)
        expect(products.select(&:inactive?).size).to eq(0)
      end
    end

    context 'when more than one version for the same seller is "approved"' do
      let(:version) { create(:approved_seller_version) }

      it 'cannot be approved' do
        expect(subject.may_approve?).to be_falsey
      end
    end
  end
end
