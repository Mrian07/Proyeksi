

require 'spec_helper'

describe ProyeksiApp::Storage do
  before do
    allow(Setting).to receive(:enabled_scm).and_return(enabled_scms)
    allow(ProyeksiApp::Configuration).to receive(:[]).and_call_original
    allow(ProyeksiApp::Configuration).to receive(:[]).with('scm').and_return(config)
  end

  context 'with no SCM configuration' do
    let(:config) { {} }
    let(:enabled_scms) { [] }

    describe '#known_storage_paths' do
      subject { ProyeksiApp::Storage.known_storage_paths }
      it 'should contain attachments path' do
        expect(subject.length).to be == 1
        expect(subject[:attachments])
          .to eq(label: I18n.t('attributes.attachments'),
                 path: ProyeksiApp::Configuration.attachments_storage_path.to_s)
      end
    end

    describe '#mount_information' do
      subject { ProyeksiApp::Storage.mount_information }
      include_context 'with tmpdir'

      before do
        allow(ProyeksiApp::Storage).to receive(:known_storage_paths)
          .and_return(foobar: { path: tmpdir, label: 'this is foobar' })
      end

      it 'should contain one fs entry' do
        expect(File.exists?(tmpdir)).to be true
        expect(subject.length).to be == 1

        entry = subject.values.first
        expect(entry[:labels]).to eq(['this is foobar'])
        expect(entry[:data]).not_to be_nil
        expect(entry[:data][:free]).to be_kind_of(Integer)
      end
    end
  end

  context 'with SCM configuration' do
    include_context 'with tmpdir'

    let(:config) do
      {
        git: { manages: File.join(tmpdir, 'git') }
      }
    end
    let(:enabled_scms) { %w[git] }
    let(:returned_fs_info) { [{ id: 1, free: 1234 }] }

    before do
      # Mock filesystem info as we do not know there /tmp is mounted here.
      allow(ProyeksiApp::Storage).to receive(:read_fs_info).and_return(*returned_fs_info)
    end

    describe '#known_storage_paths' do
      subject { ProyeksiApp::Storage.known_storage_paths }

      it 'contains both paths' do
        expect(subject.length).to be == 2

        labels = subject.values.map { |h| h[:label] }
        expect(labels)
          .to match_array([I18n.t(:label_managed_repositories_vendor, vendor: 'Git'),
                           I18n.t('attributes.attachments')])
      end
    end

    describe '#mount_information' do
      subject { ProyeksiApp::Storage.mount_information }
      it 'contains one entry' do
        expect(subject.length).to eq(1)

        entry = subject.values.first
        expect(entry[:labels])
          .to match_array([I18n.t(:label_managed_repositories_vendor, vendor: 'Git'),
                           I18n.t('attributes.attachments')])
      end

      context 'with multiple filesystem ids' do
        let(:returned_fs_info) { [{ id: 1, free: 1234 }, { id: 2, free: 15 }] }
        it 'contains two entries' do
          expect(subject.length).to eq(2)
          expect(subject)
            .to eq(1 => { labels: [I18n.t(:label_managed_repositories_vendor, vendor: 'Git')],
                          data: returned_fs_info[0] },
                   2 => { labels: [I18n.t('attributes.attachments')],
                          data: returned_fs_info[1] })
        end
      end
    end
  end
end
