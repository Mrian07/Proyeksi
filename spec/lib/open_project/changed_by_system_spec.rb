

require 'spec_helper'

describe OpenProject::ChangedBySystem do
  subject(:model) do
    model = News.new
    model.extend(described_class)
    model
  end

  describe '#changed_by_user' do
    context 'when an attribute is changed' do
      before do
        model.title = 'abc'
      end

      it 'returns the attribute' do
        expect(model.changed_by_user)
          .to match_array ['title']
      end
    end

    context 'when an attribute is changed by the system' do
      before do
        model.change_by_system do
          model.title = 'abc'
        end
      end

      it 'returns no attributes' do
        expect(model.changed_by_user)
          .to be_empty
      end
    end

    context 'when an attribute is changed by the system first and then by the user to a different value' do
      before do
        model.change_by_system do
          model.title = 'abc'
        end

        model.title = 'xyz'
      end

      it 'returns the attribute' do
        expect(model.changed_by_user)
          .to match_array ['title']
      end
    end

    context 'when an attribute is changed by the system first and then by the user to the same value' do
      before do
        model.change_by_system do
          model.title = 'abc'
        end

        model.title = 'abc'
      end

      it 'returns no attribute' do
        expect(model.changed_by_user)
          .to be_empty
      end
    end
  end
end
