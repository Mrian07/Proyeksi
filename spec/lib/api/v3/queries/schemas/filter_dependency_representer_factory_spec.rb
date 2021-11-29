

require 'spec_helper'

describe ::API::V3::Queries::Schemas::FilterDependencyRepresenterFactory do
  include ::API::V3::Utilities::PathHelper

  let(:operator) { Queries::Operators::Equals }
  let(:form_embedded) { true }

  describe '.create' do
    subject { described_class.create(filter, operator, form_embedded: form_embedded) }

    context 'assigned to filter' do
      let(:filter) { Queries::WorkPackages::Filter::AssignedToFilter.create! }

      it 'is a all principals dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::AllPrincipalsFilterDependencyRepresenter)
      end
    end

    context 'responsible filter' do
      let(:filter) { Queries::WorkPackages::Filter::ResponsibleFilter.create! }

      it 'is a all principals dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::AllPrincipalsFilterDependencyRepresenter)
      end
    end

    context 'author filter' do
      let(:filter) { Queries::WorkPackages::Filter::AuthorFilter.create! }

      it 'is the user dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::UserFilterDependencyRepresenter)
      end
    end

    context 'category filter' do
      let(:filter) { Queries::WorkPackages::Filter::CategoryFilter.create! }

      it 'is the category dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::CategoryFilterDependencyRepresenter)
      end
    end

    context 'created_at filter' do
      let(:filter) { Queries::WorkPackages::Filter::CreatedAtFilter.create! }

      it 'is the date dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::DateTimeFilterDependencyRepresenter)
      end
    end

    context 'custom_field filters' do
      let(:filter) do
        Queries::WorkPackages::Filter::CustomFieldFilter.from_custom_field! custom_field: custom_field
      end

      shared_examples_for 'includes the cf json_cache_key mixin' do
        it do
          expect(subject.singleton_class.included_modules)
            .to include(::API::V3::Queries::Schemas::CustomFieldJsonCacheKeyMixin)
        end
      end

      context 'type int' do
        let(:custom_field) { FactoryBot.build_stubbed(:int_wp_custom_field) }

        it 'is the integer dependency' do
          is_expected.to be_a(::API::V3::Queries::Schemas::IntegerFilterDependencyRepresenter)
        end

        it_behaves_like 'includes the cf json_cache_key mixin'
      end

      context 'type float' do
        let(:custom_field) { FactoryBot.build_stubbed(:float_wp_custom_field) }

        it 'is the float dependency' do
          is_expected.to be_a(::API::V3::Queries::Schemas::FloatFilterDependencyRepresenter)
        end

        it_behaves_like 'includes the cf json_cache_key mixin'
      end

      context 'type text' do
        let(:custom_field) { FactoryBot.build_stubbed(:text_wp_custom_field) }

        it 'is the text dependency' do
          is_expected.to be_a(::API::V3::Queries::Schemas::TextFilterDependencyRepresenter)
        end

        it_behaves_like 'includes the cf json_cache_key mixin'
      end

      context 'type list' do
        let(:custom_field) { FactoryBot.build_stubbed(:list_wp_custom_field) }

        it 'is the custom option dependency' do
          is_expected.to be_a(::API::V3::Queries::Schemas::CustomOptionFilterDependencyRepresenter)
        end

        it_behaves_like 'includes the cf json_cache_key mixin'
      end

      context 'type user' do
        let(:custom_field) { FactoryBot.build_stubbed(:user_wp_custom_field) }

        it 'is the user dependency' do
          is_expected.to be_a(::API::V3::Queries::Schemas::UserFilterDependencyRepresenter)
        end

        it_behaves_like 'includes the cf json_cache_key mixin'
      end

      context 'type version' do
        let(:custom_field) { FactoryBot.build_stubbed(:version_wp_custom_field) }

        it 'is the version dependency' do
          is_expected.to be_a(::API::V3::Queries::Schemas::VersionFilterDependencyRepresenter)
        end

        it_behaves_like 'includes the cf json_cache_key mixin'
      end

      context 'type date' do
        let(:custom_field) { FactoryBot.build_stubbed(:date_wp_custom_field) }

        it 'is the date dependency' do
          is_expected.to be_a(::API::V3::Queries::Schemas::DateFilterDependencyRepresenter)
        end

        it_behaves_like 'includes the cf json_cache_key mixin'
      end

      context 'type bool' do
        let(:custom_field) { FactoryBot.build_stubbed(:bool_wp_custom_field) }

        it 'is the boolean filter dependency' do
          is_expected.to be_a(::API::V3::Queries::Schemas::BooleanFilterDependencyRepresenter)
        end

        it_behaves_like 'includes the cf json_cache_key mixin'
      end

      context 'type string' do
        let(:custom_field) { FactoryBot.build_stubbed(:string_wp_custom_field) }

        it 'is the text dependency' do
          is_expected.to be_a(::API::V3::Queries::Schemas::TextFilterDependencyRepresenter)
        end

        it_behaves_like 'includes the cf json_cache_key mixin'
      end
    end

    context 'done_ratio filter' do
      let(:filter) { Queries::WorkPackages::Filter::DoneRatioFilter.create! }

      it 'is the integer dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::IntegerFilterDependencyRepresenter)
      end
    end

    context 'due_date filter' do
      let(:filter) { Queries::WorkPackages::Filter::DueDateFilter.create! }

      it 'is the date dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::DateFilterDependencyRepresenter)
      end
    end

    context 'estimated_hours filter' do
      let(:filter) { Queries::WorkPackages::Filter::EstimatedHoursFilter.create! }

      it 'is the integer dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::IntegerFilterDependencyRepresenter)
      end
    end

    context 'group filter' do
      let(:filter) { Queries::WorkPackages::Filter::GroupFilter.create! }

      it 'is the group dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::GroupFilterDependencyRepresenter)
      end
    end

    context 'id filter' do
      let(:filter) { Queries::WorkPackages::Filter::IdFilter.create! }

      it 'is the id dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::IdFilterDependencyRepresenter)
      end
    end

    context 'prioritiy filter' do
      let(:filter) { Queries::WorkPackages::Filter::PriorityFilter.create! }

      it 'is the priority dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::PriorityFilterDependencyRepresenter)
      end
    end

    context 'project filter' do
      let(:filter) { Queries::WorkPackages::Filter::ProjectFilter.create! }

      it 'is the project dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::ProjectFilterDependencyRepresenter)
      end
    end

    context 'role filter' do
      let(:filter) { Queries::WorkPackages::Filter::RoleFilter.create! }

      it 'is the role dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::RoleFilterDependencyRepresenter)
      end
    end

    context 'start_date filter' do
      let(:filter) { Queries::WorkPackages::Filter::StartDateFilter.create! }

      it 'is the date dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::DateFilterDependencyRepresenter)
      end
    end

    context 'subject filter' do
      let(:filter) { Queries::WorkPackages::Filter::SubjectFilter.create! }

      it 'is the subject dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::TextFilterDependencyRepresenter)
      end
    end

    context 'status filter' do
      let(:filter) { Queries::WorkPackages::Filter::StatusFilter.create! }

      it 'is a status dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::StatusFilterDependencyRepresenter)
      end
    end

    context 'subproject filter' do
      let(:filter) { Queries::WorkPackages::Filter::SubprojectFilter.create! }

      it 'is a subproject dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::SubprojectFilterDependencyRepresenter)
      end
    end

    context 'type filter' do
      let(:filter) { Queries::WorkPackages::Filter::TypeFilter.create! }

      it 'is a type dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::TypeFilterDependencyRepresenter)
      end
    end

    context 'updated_at filter' do
      let(:filter) { Queries::WorkPackages::Filter::UpdatedAtFilter.create! }

      it 'is a type dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::DateTimeFilterDependencyRepresenter)
      end
    end

    context 'version filter' do
      let(:filter) { Queries::WorkPackages::Filter::VersionFilter.create! }

      it 'is a version dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::VersionFilterDependencyRepresenter)
      end
    end

    context 'watcher filter' do
      let(:filter) { Queries::WorkPackages::Filter::WatcherFilter.create! }

      it 'is a type dependency' do
        is_expected.to be_a(::API::V3::Queries::Schemas::UserFilterDependencyRepresenter)
      end
    end
  end
end
