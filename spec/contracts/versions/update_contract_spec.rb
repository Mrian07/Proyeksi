

require 'spec_helper'
require_relative './shared_contract_examples'

describe Versions::UpdateContract do
  it_behaves_like 'version contract' do
    let(:version) do
      FactoryBot.build_stubbed(:version,
                               project: version_project,
                               description: version_description,
                               start_date: version_start_date,
                               effective_date: version_due_date,
                               status: version_status,
                               sharing: version_sharing,
                               wiki_page_title: version_wiki_page_title).tap do |v|
        # in order to actually have something changed
        v.name = version_name
      end
    end

    subject(:contract) { described_class.new(version, current_user) }

    describe 'assignable_values' do
      context 'for project' do
        it 'is empty' do
          expect(subject.assignable_values(:project, current_user))
            .to be_empty
        end
      end

      context 'for status' do
        it 'is a list of all available status' do
          expect(subject.assignable_values(:status, current_user))
            .to eql %w(open locked closed)
        end
      end

      context 'for sharing' do
        it 'is a list of values' do
          expect(subject.assignable_values(:sharing, current_user))
            .to match_array %w(none descendants hierarchy tree)
        end

        context 'if the user is admin' do
          let(:current_user) { FactoryBot.build_stubbed(:admin) }

          it 'is a list of values' do
            expect(subject.assignable_values(:sharing, current_user))
              .to match_array %w(none descendants system hierarchy tree)
          end
        end
      end

      context 'for something else' do
        it 'is nil' do
          expect(subject.assignable_values(:start_date, current_user))
            .to be_nil
        end
      end
    end
  end
end
