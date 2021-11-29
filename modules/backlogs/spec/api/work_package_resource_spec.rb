

require 'spec_helper'
require 'rack/test'

describe 'API v3 Work package resource' do
  include Rack::Test::Methods
  include Capybara::RSpecMatchers

  let(:current_user) { FactoryBot.create(:admin) }
  let(:project) { FactoryBot.create(:project) }
  let(:work_package) do
    FactoryBot.create(:work_package,
                      project: project,
                      story_points: 8,
                      remaining_hours: 5)
  end
  let(:wp_path) { "/api/v3/work_packages/#{work_package.id}" }

  before do
    allow(Story).to receive(:types).and_return([work_package.type_id])
  end

  describe '#get' do
    shared_context 'query work package' do
      before do
        allow(User).to receive(:current).and_return(current_user)
        get wp_path
      end

      subject { last_response.body }
    end

    context 'backlogs activated' do
      include_context 'query work package'

      it { is_expected.to be_json_eql(work_package.story_points.to_json).at_path('storyPoints') }

      it { is_expected.to be_json_eql('PT5H'.to_json).at_path('remainingTime') }
    end

    context 'backlogs deactivated' do
      let(:project) do
        FactoryBot.create(:project, disable_modules: 'backlogs')
      end

      include_context 'query work package'

      it { expect(last_response.status).to eql 200 }

      it { is_expected.not_to have_json_path('storyPoints') }

      it { is_expected.not_to have_json_path('remainingTime') }
    end
  end

  describe '#patch' do
    let(:valid_params) do
      {
        _type: 'WorkPackage',
        lockVersion: work_package.lock_version
      }
    end

    subject { last_response }

    before do
      allow(User).to receive(:current).and_return current_user
      patch wp_path, params.to_json, 'CONTENT_TYPE' => 'application/json'
    end

    describe 'storyPoints' do
      let(:params) { valid_params.merge(storyPoints: 12) }

      it { expect(subject.status).to eq(200) }
      it { expect(subject.body).to be_json_eql(12.to_json).at_path('storyPoints') }
    end

    describe 'remainingTime' do
      let(:params) { valid_params.merge(remainingTime: 'PT12H30M') }

      it { expect(subject.status).to eq(200) }
      it { expect(subject.body).to be_json_eql('PT12H30M'.to_json).at_path('remainingTime') }
    end
  end
end
