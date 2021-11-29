

require 'spec_helper'

describe TypesHelper, type: :helper do
  let(:type) { FactoryBot.build_stubbed(:type) }

  describe "#form_configuration_groups" do
    it "returns a Hash with the keys :actives and :inactives Arrays" do
      expect(helper.form_configuration_groups(type)[:actives]).to be_an Array
      expect(helper.form_configuration_groups(type)[:inactives]).to be_an Array
    end

    describe ":inactives" do
      subject { helper.form_configuration_groups(type)[:inactives] }

      before do
        allow(type)
          .to receive(:attribute_groups)
          .and_return [::Type::AttributeGroup.new(type, 'group one', ["assignee"])]
      end

      it 'contains Hashes ordered by key :translation' do
        # The first left over attribute should currently be "date"
        expect(subject.first[:translation]).to be_present
        expect(subject.first[:translation] <= subject.second[:translation]).to be_truthy
      end

      # The "assignee" is in "group one". It should not appear in :inactives.
      it 'does not contain attributes that do not exist anymore' do
        expect(subject.map { |inactive| inactive[:key] }).to_not include "assignee"
      end
    end

    describe ":actives" do
      subject { helper.form_configuration_groups(type)[:actives] }

      before do
        allow(type)
          .to receive(:attribute_groups)
          .and_return [::Type::AttributeGroup.new(type, 'group one', ["date"])]
      end

      it 'has a proper structure' do
        # The group's name/key
        expect(subject.first[:name]).to eq "group one"

        # The groups attributes
        expect(subject.first[:attributes]).to be_an Array
        expect(subject.first[:attributes].first[:key]).to eq "date"
        expect(subject.first[:attributes].first[:translation]).to eq "Date"
      end
    end
  end
end
