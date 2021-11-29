#-- encoding: UTF-8

require 'rspec'

require 'spec_helper'
require_relative './eager_loading_mock_wrapper'

describe ::API::V3::WorkPackages::EagerLoading::CustomValue do
  let!(:work_package) { FactoryBot.create(:work_package) }
  let!(:type) { work_package.type }
  let!(:other_type) { FactoryBot.create(:type) }
  let!(:project) { work_package.project }
  let!(:other_project) { FactoryBot.create(:project) }
  let!(:user) { FactoryBot.create(:user) }
  let!(:version) { FactoryBot.create(:version, project: project) }

  describe 'multiple CFs' do
    let!(:type_project_list_cf) do
      FactoryBot.create(:list_wp_custom_field).tap do |cf|
        type.custom_fields << cf
        project.work_package_custom_fields << cf
      end
    end
    let!(:type_project_user_cf) do
      FactoryBot.create(:user_wp_custom_field).tap do |cf|
        type.custom_fields << cf
        project.work_package_custom_fields << cf
      end
    end
    let!(:type_project_version_cf) do
      FactoryBot.create(:version_wp_custom_field, name: 'blubs').tap do |cf|
        type.custom_fields << cf
        project.work_package_custom_fields << cf
      end
    end
    let!(:for_all_type_cf) do
      FactoryBot.create(:list_wp_custom_field, is_for_all: true).tap do |cf|
        type.custom_fields << cf
      end
    end
    let!(:for_all_other_type_cf) do
      FactoryBot.create(:list_wp_custom_field, is_for_all: true).tap do |cf|
        other_type.custom_fields << cf
      end
    end
    let!(:type_other_project_cf) do
      FactoryBot.create(:list_wp_custom_field).tap do |cf|
        type.custom_fields << cf
        other_project.work_package_custom_fields << cf
      end
    end
    let!(:other_type_project_cf) do
      FactoryBot.create(:list_wp_custom_field).tap do |cf|
        other_type.custom_fields << cf
        project.work_package_custom_fields << cf
      end
    end

    describe '.apply' do
      it 'preloads the custom fields and values' do
        FactoryBot.create(:custom_value,
                          custom_field: type_project_list_cf,
                          customized: work_package,
                          value: type_project_list_cf.custom_options.last.id)

        FactoryBot.build(:custom_value,
                         custom_field: type_project_user_cf,
                         customized: work_package,
                         value: user.id)
                  .save(validate: false)

        FactoryBot.create(:custom_value,
                          custom_field: type_project_version_cf,
                          customized: work_package,
                          value: version.id)

        work_package = WorkPackage.first
        wrapped = EagerLoadingMockWrapper.wrap(described_class, [work_package])

        expect(type)
          .not_to receive(:custom_fields)
        expect(project)
          .not_to receive(:all_work_package_custom_fields)

        [CustomOption, User, Version].each do |klass|
          expect(klass)
            .not_to receive(:find_by)
        end

        wrapped.each do |w|
          expect(w.available_custom_fields)
            .to match_array [type_project_list_cf,
                             type_project_version_cf,
                             type_project_user_cf,
                             for_all_type_cf]

          expect(work_package.send(:"custom_field_#{type_project_version_cf.id}"))
            .to eql version
          expect(work_package.send(:"custom_field_#{type_project_list_cf.id}"))
            .to eql type_project_list_cf.custom_options.last.name
          expect(work_package.send(:"custom_field_#{type_project_user_cf.id}"))
            .to eql user
        end
      end
    end
  end

  describe '#usages returning an is_for_all custom field within one project (Regression #28435)' do
    let!(:for_all_type_cf) do
      FactoryBot.create(:list_wp_custom_field, is_for_all: true).tap do |cf|
        type.custom_fields << cf
      end
    end
    let(:other_project) { FactoryBot.create :project }
    subject { described_class.new [work_package] }

    before do
      # Assume that one custom field has an entry in project_custom_fields
      for_all_type_cf.projects << other_project
    end

    it 'still allows looking up the global custom field in a different project' do
      # Exhibits the same behavior as in regression, usage returns a hash with project_id set for a global
      # custom field
      expect(for_all_type_cf.is_for_all).to eq(true)
      expect(subject.send(:usages))
        .to include("project_id" => other_project.id, "type_id" => type.id, "custom_field_id" => for_all_type_cf.id)

      wrapped = EagerLoadingMockWrapper.wrap(described_class, [work_package])
      expect(wrapped.first.available_custom_fields).to include(for_all_type_cf)
    end
  end

  describe '#usages returning an is_for_all custom field within multiple projects (Regression #28452)' do
    let!(:for_all_type_cf) do
      FactoryBot.create(:list_wp_custom_field, is_for_all: true).tap do |cf|
        type.custom_fields << cf
      end
    end
    let(:other_project) { FactoryBot.create :project }
    let(:other_project2) { FactoryBot.create :project }
    subject { described_class.new [work_package] }

    before do
      # Assume that one custom field has an entry in project_custom_fields
      for_all_type_cf.projects << other_project
      for_all_type_cf.projects << other_project2
    end

    it 'does not double add the custom field to the available CFs' do
      # Exhibits the same behavior as in regression, usage returns a hash with project_id set for a global
      # custom field
      expect(for_all_type_cf.is_for_all).to eq(true)
      expect(subject.send(:usages))
        .to include("project_id" => other_project.id, "type_id" => type.id, "custom_field_id" => for_all_type_cf.id)

      expect(subject.send(:usages))
        .to include("project_id" => other_project2.id, "type_id" => type.id, "custom_field_id" => for_all_type_cf.id)

      wrapped = EagerLoadingMockWrapper.wrap(described_class, [work_package])
      expect(wrapped.first.available_custom_fields.length).to eq(1)
      expect(wrapped.first.available_custom_fields.to_a).to eq([for_all_type_cf])
    end
  end
end
