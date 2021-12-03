

require 'spec_helper'

describe ::API::V3::Queries::Filters::QueryFilterInstanceRepresenter do
  let(:operator) { '=' }
  let(:filter) do
    ::Bim::Queries::WorkPackages::Filter::BcfIssueAssociatedFilter
      .create!(name: "bcf_issue_associated", operator: operator, values: values)
  end

  let(:representer) { described_class.new(filter) }

  describe 'generation' do
    subject { representer.to_json }

    context 'with a bool bcf_associated_filter' do
      context "with 't' as filter value" do
        let(:values) { [ProyeksiApp::Database::DB_VALUE_TRUE] }

        it "has `true` for 'values'" do
          is_expected
            .to be_json_eql([true].to_json)
                  .at_path('values')
        end
      end

      context "with 'f' as filter value" do
        let(:values) { [ProyeksiApp::Database::DB_VALUE_FALSE] }

        it "has `true` for 'values'" do
          is_expected
            .to be_json_eql([false].to_json)
                  .at_path('values')
        end
      end

      context "with something as filter value" do
        let(:values) { ['blubs'] }

        it "has `false` for 'values'" do
          is_expected
            .to be_json_eql([false].to_json)
                  .at_path('values')
        end
      end
    end
  end
end
