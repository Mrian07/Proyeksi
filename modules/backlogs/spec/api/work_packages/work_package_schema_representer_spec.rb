

require 'spec_helper'

describe ::API::V3::WorkPackages::Schema::WorkPackageSchemaRepresenter do
  let(:custom_field) { FactoryBot.build(:custom_field) }
  let(:work_package) { FactoryBot.build_stubbed(:stubbed_work_package, type: FactoryBot.build_stubbed(:type)) }
  let(:current_user) do
    FactoryBot.build_stubbed(:user, member_in_project: work_package.project).tap do |u|
      allow(u)
        .to receive(:allowed_to?)
        .and_return(false)
      allow(u)
        .to receive(:allowed_to?)
        .with(:edit_work_packages, work_package.project, global: false)
        .and_return(true)
    end
  end
  let(:schema) do
    ::API::V3::WorkPackages::Schema::SpecificWorkPackageSchema.new(work_package: work_package)
  end
  let(:representer) { described_class.create(schema, self_link: nil, current_user: current_user) }

  before do
    login_as(current_user)

    allow(schema.project).to receive(:backlogs_enabled?).and_return(true)
    allow(work_package.type).to receive(:story?).and_return(true)
    allow(work_package).to receive(:leaf?).and_return(true)
  end

  describe 'storyPoints' do
    subject { representer.to_json }

    it_behaves_like 'has basic schema properties' do
      let(:path) { 'storyPoints' }
      let(:type) { 'Integer' }
      let(:name) { I18n.t('activerecord.attributes.work_package.story_points') }
      let(:required) { false }
      let(:writable) { true }
    end

    context 'backlogs disabled' do
      before do
        allow(schema.project).to receive(:backlogs_enabled?).and_return(false)
      end

      it 'does not show story points' do
        is_expected.to_not have_json_path('storyPoints')
      end
    end

    context 'not a story' do
      before do
        allow(schema.type).to receive(:story?).and_return(false)
      end

      it 'does not show story points' do
        is_expected.to_not have_json_path('storyPoints')
      end
    end
  end

  describe 'remainingTime' do
    subject { representer.to_json }

    shared_examples_for 'has schema for remainingTime' do
      it_behaves_like 'has basic schema properties' do
        let(:path) { 'remainingTime' }
        let(:type) { 'Duration' }
        let(:name) { I18n.t('activerecord.attributes.work_package.remaining_hours') }
        let(:required) { false }
        let(:writable) { true }
      end
    end

    before do
      allow(schema).to receive(:remaining_time_writable?).and_return(true)
    end

    it_behaves_like 'has schema for remainingTime'

    context 'backlogs disabled' do
      before do
        allow(schema.project).to receive(:backlogs_enabled?).and_return(false)
      end

      it 'has no schema for remaining time' do
        is_expected.not_to have_json_path('remainingTime')
      end
    end

    context 'not a story' do
      before do
        allow(schema.type).to receive(:story?).and_return(false)
      end

      it_behaves_like 'has schema for remainingTime'
    end

    context 'remainingTime not writable' do
      before do
        allow(schema).to receive(:writable?).and_call_original
        allow(schema).to receive(:writable?).with(:remaining_time).and_return(false)
      end

      it_behaves_like 'has basic schema properties' do
        let(:path) { 'remainingTime' }
        let(:type) { 'Duration' }
        let(:name) { I18n.t('activerecord.attributes.work_package.remaining_hours') }
        let(:required) { false }
        let(:writable) { false }
      end
    end
  end
end
