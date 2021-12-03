

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper.rb')

describe ProyeksiApp::JournalFormatter::ScheduleManually do
  let(:klass) { described_class }
  let(:id) { 1 }
  let(:journal) do
    OpenStruct.new(id: id, journable: WorkPackage.new)
  end
  let(:instance) { klass.new(journal) }
  let(:key) { 'schedule_manually' }

  describe '#render' do
    describe 'with the first value being true, and the second false' do
      let(:expected) do
        I18n.t(:text_journal_label_value,
               label: "<strong>Manual scheduling</strong>",
               value: 'deactivated')
      end

      it { expect(instance.render(key, [true, false])).to eq(expected) }
    end

    describe 'with the first value being false, and the second true' do
      let(:expected) do
        I18n.t(:text_journal_label_value,
               label: "<strong>Manual scheduling</strong>",
               value: 'activated')
      end

      it { expect(instance.render(key, [false, true])).to eq(expected) }
    end
  end
end
