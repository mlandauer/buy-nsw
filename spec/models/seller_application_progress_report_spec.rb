require 'rails_helper'

RSpec.describe SellerApplicationProgressReport do
  class BaseStepOne < SellerVersions::BaseForm
    property :name

    validation :default do
      required(:name).filled
    end
  end
  class BaseStepTwo < SellerVersions::BaseForm
    property :contact_name

    validation :default do
      required(:contact_name).filled
    end
  end

  class ProductStepOne < Products::BaseForm
    property :name

    validation :default do
      required(:name).filled
    end
  end
  class ProductStepTwo < Products::BaseForm
    property :summary

    validation :default do
      required(:summary).filled
    end
  end

  subject do
    described_class.new(
      application: seller_version,
      base_steps: base_steps,
      product_steps: product_steps,
    )
  end

  let(:seller_version) { create(:created_seller_version) }

  let(:base_steps) do
    [
      Sellers::Applications::StepPresenter.new(BaseStepOne),
      Sellers::Applications::StepPresenter.new(BaseStepTwo),
    ]
  end
  let(:product_steps) do
    [
      Sellers::Applications::ProductStepPresenter.new(ProductStepOne),
      Sellers::Applications::ProductStepPresenter.new(ProductStepTwo),
    ]
  end

  let(:valid_base_atts) do
    { name: 'Name', contact_name: 'Contact Name' }
  end
  let(:valid_product_atts) do
    { name: 'Name', summary: 'Summary' }
  end

  describe "#all_steps_valid?" do
    context 'when all steps are valid' do
      before(:each) do
        seller_version.update_attributes(valid_base_atts)
      end

      it 'returns true' do
        expect(subject.all_steps_valid?).to be_truthy
      end
    end

    context 'when a step is invalid' do
      before(:each) do
        seller_version.update_attributes(valid_base_atts.merge(contact_name: nil))
      end

      it 'returns false' do
        expect(subject.all_steps_valid?).to be_falsey
      end
    end

    context 'when all steps and products are valid' do
      before(:each) do
        seller_version.update_attributes(valid_base_atts)
        create_list(:product, 5, seller: seller_version.seller, **valid_product_atts)
      end

      it 'returns true' do
        expect(subject.all_steps_valid?).to be_truthy
      end
    end

    context 'when steps are valid but a product is invalid' do
      before(:each) do
        seller_version.update_attributes(valid_base_atts)
        create_list(:product, 5, seller: seller_version.seller, **valid_product_atts)
        create(:product, seller: seller_version.seller, name: '', summary: '')
      end

      it 'returns true' do
        expect(subject.all_steps_valid?).to be_falsey
      end
    end
  end

  describe '#base_progress' do
    context 'when all steps are valid' do
      before(:each) do
        seller_version.update_attributes(valid_base_atts)
      end

      it 'returns a hash of which steps are valid' do
        expect(subject.base_progress).to eq({
          'base_step_one' => true,
          'base_step_two' => true,
        })
      end
    end

    context 'when a step is invalid' do
      before(:each) do
        seller_version.update_attributes(valid_base_atts.merge(contact_name: nil))
      end

      it 'returns a hash of which steps are valid' do
        expect(subject.base_progress).to eq({
          'base_step_one' => true,
          'base_step_two' => false,
        })
      end
    end
  end

  describe '#products_progress' do
    let!(:product) { create(:product, seller: seller_version.seller) }

    context 'when all steps are valid' do
      before(:each) do
        product.update_attributes(valid_product_atts)
      end

      it 'returns a hash of which steps are valid' do
        expect(subject.products_progress).to eq({
          product.id => {
            'product_step_one' => true,
            'product_step_two' => true,
            '_overall' => true,
          },
        })
      end
    end

    context 'when a step is invalid' do
      before(:each) do
        product.update_attributes(valid_product_atts.merge(summary: nil))
      end

      it 'returns a hash of which steps are valid' do
        expect(subject.products_progress).to eq({
          product.id => {
            'product_step_one' => true,
            'product_step_two' => false,
            '_overall' => false,
          },
        })
      end
    end
  end
end
