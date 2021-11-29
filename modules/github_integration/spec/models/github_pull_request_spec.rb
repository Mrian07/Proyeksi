
require "#{File.dirname(__FILE__)}/../spec_helper"

describe GithubPullRequest do
  describe "validations" do
    it { is_expected.to validate_presence_of :github_html_url }
    it { is_expected.to validate_presence_of :number }
    it { is_expected.to validate_presence_of :repository }
    it { is_expected.to validate_presence_of :state }
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :github_updated_at }

    context 'when it is not a partial pull request' do
      subject do
        described_class.new(changed_files_count: 5,
                            body: 'something',
                            comments_count: 4,
                            review_comments_count: 3,
                            additions_count: 2,
                            deletions_count: 1)
      end

      it { is_expected.to validate_presence_of :body }
      it { is_expected.to validate_presence_of :comments_count }
      it { is_expected.to validate_presence_of :review_comments_count }
      it { is_expected.to validate_presence_of :additions_count }
      it { is_expected.to validate_presence_of :deletions_count }
      it { is_expected.to validate_presence_of :changed_files_count }
    end

    describe 'labels' do
      it { is_expected.to allow_value(nil).for(:labels) }
      it { is_expected.to allow_value([]).for(:labels) }
      it { is_expected.to allow_value([{ 'color' => '#666', 'name' => 'grey' }]).for(:labels) }
      it { is_expected.not_to allow_value([{ 'name' => 'grey' }]).for(:labels) }
      it { is_expected.not_to allow_value([{}]).for(:labels) }
    end
  end

  describe '.without_work_package' do
    subject { described_class.without_work_package }

    let(:pull_request) { FactoryBot.create(:github_pull_request, work_packages: work_packages) }
    let(:work_packages) { [] }

    before { pull_request }

    it { is_expected.to match_array([pull_request]) }

    context 'when the pr is linked to a work_package' do
      let(:work_packages) { FactoryBot.create_list(:work_package, 1) }

      it { is_expected.to be_empty }
    end
  end

  describe '.find_by_github_identifiers' do
    let(:github_id) { 5 }
    let(:github_url) { 'https://github.com/opf/openproject/pull/123' }
    let(:pull_request) do
      FactoryBot.create(:github_pull_request,
                        github_id: github_id,
                        github_html_url: github_url)
    end

    context 'when the github_id attribute matches' do
      it 'finds by github_id' do
        expect(described_class.find_by_github_identifiers(id: pull_request.github_id))
          .to eql pull_request
      end
    end

    context 'when the github_html_url attribute matches' do
      it 'finds by github_html_url' do
        expect(described_class.find_by_github_identifiers(url: pull_request.github_html_url))
          .to eql pull_request
      end
    end

    context 'when the provided github_id does not match' do
      it 'is nil' do
        expect(described_class.find_by_github_identifiers(id: pull_request.github_id + 1))
          .to be_nil
      end
    end

    context 'when the provided github_html_url does not match' do
      it 'is nil' do
        expect(described_class.find_by_github_identifiers(url: "#{pull_request.github_html_url}zzzz"))
          .to be_nil
      end
    end

    context 'when neither match' do
      it 'is nil' do
        expect(described_class.find_by_github_identifiers(id: pull_request.github_id + 1,
                                                          url: "#{pull_request.github_html_url}zzzz"))
          .to be_nil
      end
    end

    context 'when the provided github_html_url does not match but the github_id does' do
      it 'is nil' do
        expect(described_class.find_by_github_identifiers(id: pull_request.github_id,
                                                          url: "#{pull_request.github_html_url}zzzz"))
          .to eql pull_request
      end
    end

    context 'when the provided github_html_url does match but the github_id does not' do
      it 'is nil' do
        expect(described_class.find_by_github_identifiers(id: pull_request.github_id + 1,
                                                          url: pull_request.github_html_url))
          .to eql pull_request
      end
    end

    context 'when neither match but initialize is true' do
      subject(:finder) do
        described_class.find_by_github_identifiers(id: pull_request.github_id + 1,
                                                   url: "#{pull_request.github_html_url}zzzz",
                                                   initialize: true)
      end

      it 'returns a pull reqeust' do
        expect(finder)
          .to be_a(described_class)
      end

      it 'returns a new record' do
        expect(finder)
          .to be_new_record
      end

      it 'has the privided attributes initialized' do
        expect(finder.attributes.compact)
          .to eql("github_id" => pull_request.github_id + 1,
                  "github_html_url" => "#{pull_request.github_html_url}zzzz")
      end
    end
  end

  describe '#latest_check_runs' do
    subject { pull_request.reload.latest_check_runs }

    let(:pull_request) { FactoryBot.create(:github_pull_request) }

    it { is_expected.to be_empty }

    context 'when multiple check_runs from different apps with different names exist' do
      let(:latest_check_runs) do
        [
          FactoryBot.create(
            :github_check_run,
            app_id: 123,
            name: 'test',
            started_at: 1.minute.ago,
            github_pull_request: pull_request
          ),
          FactoryBot.create(
            :github_check_run,
            app_id: 123,
            name: 'lint',
            started_at: 1.minute.ago,
            github_pull_request: pull_request
          ),
          FactoryBot.create(
            :github_check_run,
            app_id: 456,
            name: 'test',
            started_at: 1.minute.ago,
            github_pull_request: pull_request
          ),
          FactoryBot.create(
            :github_check_run,
            app_id: 789,
            name: 'test',
            started_at: 1.minute.ago,
            github_pull_request: pull_request
          )
        ]
      end
      let(:outdated_check_runs) do
        [
          FactoryBot.create(
            :github_check_run,
            app_id: 123,
            name: 'test',
            started_at: 2.minutes.ago,
            github_pull_request: pull_request
          ),
          FactoryBot.create(
            :github_check_run,
            app_id: 123,
            name: 'test',
            started_at: 3.minutes.ago,
            github_pull_request: pull_request
          ),
          FactoryBot.create(
            :github_check_run,
            app_id: 123,
            name: 'lint',
            started_at: 5.minutes.ago,
            github_pull_request: pull_request
          )
        ]
      end
      let(:check_runs) { latest_check_runs + outdated_check_runs }

      before { check_runs }

      it { is_expected.to match_array(latest_check_runs) }
    end
  end
end
