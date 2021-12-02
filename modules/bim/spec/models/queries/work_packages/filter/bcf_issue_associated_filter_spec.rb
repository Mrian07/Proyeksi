#-- encoding: UTF-8


require 'spec_helper'

describe Bim::Queries::WorkPackages::Filter::BcfIssueAssociatedFilter, type: :model do
  include_context 'filter tests'
  let(:values) { [ProyeksiApp::Database::DB_VALUE_TRUE] }

  it_behaves_like 'basic query filter' do
    let(:class_key) { :bcf_issue_associated }
    let(:type) { :list }

    describe '#available?' do
      context 'if bim is enabled', with_config: { edition: 'bim' } do
        it 'is available' do
          expect(instance)
            .to be_available
        end
      end

      context 'if bim is disabled' do
        it 'is not available' do
          expect(instance)
            .not_to be_available
        end
      end
    end
  end
end
