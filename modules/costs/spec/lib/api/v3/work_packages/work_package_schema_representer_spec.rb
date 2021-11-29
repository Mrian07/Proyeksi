

require 'spec_helper'

describe ::API::V3::WorkPackages::Schema::WorkPackageSchemaRepresenter do
  let(:custom_field) { FactoryBot.build(:custom_field) }
  let(:work_package) { FactoryBot.build_stubbed(:stubbed_work_package) }
  let(:current_user) do
    FactoryBot.build_stubbed(:user).tap do |u|
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
  let(:embedded) { false }
  let(:representer) do
    described_class.create(schema,
                           self_link: nil,
                           form_embedded: embedded,
                           current_user: current_user)
  end
  let(:project) { work_package.project }

  subject { representer.to_json }

  before do
    login_as(current_user)
  end

  describe 'overallCosts' do
    context 'has the permissions' do
      before do
        allow(project)
          .to receive(:costs_enabled?)
          .and_return(true)
      end

      it_behaves_like 'has basic schema properties' do
        let(:path) { 'overallCosts' }
        let(:type) { 'String' }
        let(:name) { I18n.t('activerecord.attributes.work_package.overall_costs') }
        let(:required) { false }
        let(:writable) { false }
      end
    end

    context 'lacks the permissions' do
      before do
        allow(project)
          .to receive(:costs_enabled?)
          .and_return(false)
      end

      it { is_expected.not_to have_json_path('overallCosts') }
    end
  end

  describe 'laborCosts' do
    context 'has the permissions' do
      before do
        allow(project)
          .to receive(:costs_enabled?)
          .and_return(true)
      end

      it_behaves_like 'has basic schema properties' do
        let(:path) { 'laborCosts' }
        let(:type) { 'String' }
        let(:name) { I18n.t('activerecord.attributes.work_package.labor_costs') }
        let(:required) { false }
        let(:writable) { false }
      end
    end

    context 'lacks the permissions' do
      before do
        allow(project)
          .to receive(:costs_enabled?)
          .and_return(false)
      end

      it { is_expected.not_to have_json_path('laborCosts') }
    end
  end

  describe 'materialCosts' do
    context 'has the permissions' do
      before do
        allow(project)
          .to receive(:costs_enabled?)
          .and_return(true)
      end

      it_behaves_like 'has basic schema properties' do
        let(:path) { 'materialCosts' }
        let(:type) { 'String' }
        let(:name) { I18n.t('activerecord.attributes.work_package.material_costs') }
        let(:required) { false }
        let(:writable) { false }
      end
    end

    context 'lacks the permissions' do
      before do
        allow(project)
          .to receive(:costs_enabled?)
          .and_return(false)
      end

      it { is_expected.not_to have_json_path('materialCosts') }
    end
  end

  describe 'costsByType' do
    context 'has the permissions' do
      before do
        allow(project)
          .to receive(:costs_enabled?)
          .and_return(true)
      end

      it_behaves_like 'has basic schema properties' do
        let(:path) { 'costsByType' }
        let(:type) { 'Collection' }
        let(:name) { I18n.t('activerecord.attributes.work_package.spent_units') }
        let(:required) { false }
        let(:writable) { false }
      end
    end

    context 'lacks the permissions' do
      before do
        allow(project)
          .to receive(:costs_enabled?)
          .and_return(false)
      end

      it { is_expected.not_to have_json_path('costsByType') }
    end
  end
end
