

require 'spec_helper'

describe ::API::V3::ParseQueryParamsService,
         type: :model do
  let(:instance) { described_class.new }
  let(:params) { {} }

  describe '#call' do
    subject { instance.call(params) }

    shared_examples_for 'transforms' do
      it 'is success' do
        expect(subject)
          .to be_success
      end

      it 'is transformed' do
        expect(subject.result)
          .to eql(expected)
      end
    end

    context 'with group by' do
      context 'as groupBy' do
        it_behaves_like 'transforms' do
          let(:params) { { groupBy: 'status' } }
          let(:expected) { { group_by: 'status' } }
        end
      end

      context 'as group_by' do
        it_behaves_like 'transforms' do
          let(:params) { { group_by: 'status' } }
          let(:expected) { { group_by: 'status' } }
        end
      end

      context 'as "g"' do
        it_behaves_like 'transforms' do
          let(:params) { { g: 'status' } }
          let(:expected) { { group_by: 'status' } }
        end
      end

      context 'set to empty string' do
        it_behaves_like 'transforms' do
          let(:params) { { g: '' } }
          let(:expected) { { group_by: nil } }
        end

        it_behaves_like 'transforms' do
          let(:params) { { group_by: '' } }
          let(:expected) { { group_by: nil } }
        end

        it_behaves_like 'transforms' do
          let(:params) { { groupBy: '' } }
          let(:expected) { { group_by: nil } }
        end
      end

      context 'not given' do
        let(:params) { { bla: 'foo' } }
        it 'does not set group_by' do
          expect(subject).to be_success
          expect(subject.result).not_to have_key(:group_by)
        end
      end

      context 'with an attribute called differently in v3' do
        it_behaves_like 'transforms' do
          let(:params) { { groupBy: 'assignee' } }
          let(:expected) { { group_by: 'assigned_to' } }
        end
      end
    end

    context 'with columns' do
      context 'as columns' do
        it_behaves_like 'transforms' do
          let(:params) { { columns: %w(status assignee) } }
          let(:expected) { { columns: %w(status assigned_to) } }
        end
      end

      context 'as "c"' do
        it_behaves_like 'transforms' do
          let(:params) { { c: %w(status assignee) } }
          let(:expected) { { columns: %w(status assigned_to) } }
        end
      end

      context 'as column_names' do
        it_behaves_like 'transforms' do
          let(:params) { { column_names: %w(status assignee) } }
          let(:expected) { { columns: %w(status assigned_to) } }
        end
      end
    end

    context 'with highlighted_attributes' do
      it_behaves_like 'transforms' do
        let(:params) { { highlightedAttributes: %w(status type priority dueDate) } }
        # Please note, that dueDate is expected to get translated to due_date.
        let(:expected) { { highlighted_attributes: %w(status type priority due_date) } }
      end

      it_behaves_like 'transforms' do
        let(:params) { { highlightedAttributes: %w(/api/v3/columns/status /api/v3/columns/type) } }
        # Please note, that dueDate is expected to get translated to due_date.
        let(:expected) { { highlighted_attributes: %w(status type) } }
      end
    end

    context 'without highlighted_attributes' do
      it_behaves_like 'transforms' do
        let(:params) { { highlightedAttributes: nil } }
        let(:expected) { {} }
      end
    end

    context 'with display_representation' do
      it_behaves_like 'transforms' do
        let(:params) { { displayRepresentation: 'cards' } }
        let(:expected) { { display_representation: 'cards' } }
      end
    end

    context 'without display_representation' do
      it_behaves_like 'transforms' do
        let(:params) { { displayRepresentation: nil } }
        let(:expected) { {} }
      end
    end

    context 'with sort' do
      context 'as sortBy in comma separated value' do
        it_behaves_like 'transforms' do
          let(:params) { { sortBy: JSON::dump([%w(status desc)]) } }
          let(:expected) { { sort_by: [%w(status desc)] } }
        end
      end

      context 'as sortBy in colon concatenated value' do
        it_behaves_like 'transforms' do
          let(:params) { { sortBy: JSON::dump(['status:desc']) } }
          let(:expected) { { sort_by: [%w(status desc)] } }
        end
      end

      context 'with an invalid JSON' do
        let(:params) { { sortBy: 'faulty' + JSON::dump(['status:desc']) } }

        it 'is not success' do
          expect(subject)
            .to_not be_success
        end

        it 'returns the error' do
          message = 'unexpected token at \'faulty["status:desc"]\''

          expect(subject.errors.messages[:base].length)
            .to eql(1)
          expect(subject.errors.messages[:base][0])
            .to end_with(message)
        end
      end
    end

    context 'with filters' do
      context 'as filters in dumped json' do
        context 'with a filter named internally' do
          it_behaves_like 'transforms' do
            let(:params) do
              { filters: JSON::dump([{ 'status_id' => { 'operator' => '=',
                                                        'values' => %w(1 2) } }]) }
            end
            let(:expected) do
              { filters: [{ field: 'status_id', operator: '=', values: %w(1 2) }] }
            end
          end
        end

        context 'with a filter named according to v3' do
          it_behaves_like 'transforms' do
            let(:params) do
              { filters: JSON::dump([{ 'status' => { 'operator' => '=',
                                                     'values' => %w(1 2) } }]) }
            end
            let(:expected) do
              { filters: [{ field: 'status_id', operator: '=', values: %w(1 2) }] }
            end
          end

          it_behaves_like 'transforms' do
            let(:params) do
              { filters: JSON::dump([{ 'subprojectId' => { 'operator' => '=',
                                                           'values' => %w(1 2) } }]) }
            end
            let(:expected) do
              { filters: [{ field: 'subproject_id', operator: '=', values: %w(1 2) }] }
            end
          end

          it_behaves_like 'transforms' do
            let(:params) do
              { filters: JSON::dump([{ 'watcher' => { 'operator' => '=',
                                                      'values' => %w(1 2) } }]) }
            end
            let(:expected) do
              { filters: [{ field: 'watcher_id', operator: '=', values: %w(1 2) }] }
            end
          end

          it_behaves_like 'transforms' do
            let(:params) do
              { filters: JSON::dump([{ 'custom_field_1' => { 'operator' => '=',
                                                             'values' => %w(1 2) } }]) }
            end
            let(:expected) do
              { filters: [{ field: 'cf_1', operator: '=', values: %w(1 2) }] }
            end
          end
        end

        context 'with an invalid JSON' do
          let(:params) do
            { filters: 'faulty' + JSON::dump([{ 'status' => { 'operator' => '=',
                                                              'values' => %w(1 2) } }]) }
          end

          it 'is not success' do
            expect(subject)
              .to_not be_success
          end

          it 'returns the error' do
            message = 'unexpected token at ' +
                      "'faulty[{\"status\":{\"operator\":\"=\",\"values\":[\"1\",\"2\"]}}]'"

            expect(subject.errors.messages[:base].length)
              .to eql(1)
            expect(subject.errors.messages[:base][0])
              .to end_with(message)
          end
        end

        context 'with an empty array (in JSON)' do
          it_behaves_like 'transforms' do
            let(:params) do
              { filters: JSON::dump([]) }
            end
            let(:expected) do
              { filters: [] }
            end
          end
        end
      end
    end

    context 'with showSums' do
      it_behaves_like 'transforms' do
        let(:params) { { showSums: 'true' } }
        let(:expected) { { display_sums: true } }
      end

      it_behaves_like 'transforms' do
        let(:params) { { showSums: 'false' } }
        let(:expected) { { display_sums: false } }
      end
    end

    context 'with timelineLabels' do
      let(:input) { { left: 'a', right: 'b', farRight: 'c' } }

      it_behaves_like 'transforms' do
        let(:params) { { timelineLabels: input.to_json } }
        let(:expected) { { timeline_labels: input.stringify_keys } }
      end
    end
  end
end
