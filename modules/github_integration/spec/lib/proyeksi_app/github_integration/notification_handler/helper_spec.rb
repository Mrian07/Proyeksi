

require File.expand_path('../../../../spec_helper', __dir__)

describe ProyeksiApp::GithubIntegration::NotificationHandler::Helper do
  subject(:handler) { Class.new.include(described_class).new }

  before do
    allow(Setting).to receive(:host_name).and_return('example.net')
  end

  describe '#extract_work_package_ids' do
    it 'returns an empty array for an empty source' do
      expect(handler.extract_work_package_ids('')).to eq([])
    end

    it 'returns an empty array for a null source' do
      expect(handler.extract_work_package_ids(nil)).to eq([])
    end

    it 'finds a work package by code' do
      source = "Blabla\nOP#1234\n"
      expect(handler.extract_work_package_ids(source)).to eq([1234])
    end

    it 'finds a plain work package url' do
      source = 'Blabla\nhttps://example.net/work_packages/234\n'
      expect(handler.extract_work_package_ids(source)).to eq([234])
    end

    it 'finds a work package url in markdown link syntax' do
      source = 'Blabla\n[WP 234](https://example.net/work_packages/234)\n'
      expect(handler.extract_work_package_ids(source)).to eq([234])
    end

    it 'finds multiple work package urls' do
      source = "I reference https://example.net/work_packages/434\n and Blabla\n[WP 234](https://example.net/wp/234)\n"
      expect(handler.extract_work_package_ids(source)).to eq([434, 234])
    end

    it 'finds multiple occurences of a work package only once' do
      source = "I reference https://example.net/work_packages/434\n and Blabla\n[WP 234](https://example.net/work_packages/434)\n"
      expect(handler.extract_work_package_ids(source)).to eq([434])
    end
  end

  describe '#find_visible_work_packages' do
    let(:user) { instance_double(User) }
    let(:visible_wp) { instance_double(WorkPackage, project: :project_with_permissions) }
    let(:invisible_wp) { instance_double(WorkPackage, project: :project_without_permissions) }

    shared_examples_for 'it finds visible work packages' do
      subject(:find_visible_work_packages) { handler.find_visible_work_packages(ids, user) }

      before do
        allow(WorkPackage).to receive(:includes).and_return(WorkPackage)
        allow(WorkPackage).to receive(:where).with(id: ids).and_return(work_packages)
        allow(user).to receive(:allowed_to?) { |permission, project|
          (permission == :add_work_package_notes) && (project == :project_with_permissions)
        }
      end

      it 'finds work packages visible to the user' do
        expect(find_visible_work_packages).to eql(expected)
        expect(user).to have_received(:allowed_to?).exactly(ids.length).times
      end
    end

    describe 'should find an existing work package' do
      let(:work_packages) { [visible_wp] }
      let(:ids) { [0] }
      let(:expected) { work_packages }

      it_behaves_like 'it finds visible work packages'
    end

    describe 'should not find a non-existing work package' do
      let(:work_packages) { [invisible_wp] }
      let(:ids) { [0] }
      let(:expected) { [] }

      it_behaves_like 'it finds visible work packages'
    end

    describe 'should find multiple existing work packages' do
      let(:work_packages) { [visible_wp, visible_wp] }
      let(:ids) { [0, 1] }
      let(:expected) { work_packages }

      it_behaves_like 'it finds visible work packages'
    end

    describe 'should not find work package which the user shall not see' do
      let(:work_packages) { [visible_wp, invisible_wp, visible_wp, invisible_wp] }
      let(:ids) { [0, 1, 2, 3] }
      let(:expected) { [visible_wp, visible_wp] }

      it_behaves_like 'it finds visible work packages'
    end
  end

  describe '#without_already_referenced' do
    let(:work_packages) { FactoryBot.create_list(:work_package, 2) }
    let(:referenced_work_packages) { [work_packages[0]] }
    let(:github_pull_request) { FactoryBot.create(:github_pull_request, work_packages: referenced_work_packages) }

    it 'returns only the not already referenced work packages' do
      expect(handler.without_already_referenced(work_packages, github_pull_request)).to match_array([work_packages[1]])
    end
  end
end
