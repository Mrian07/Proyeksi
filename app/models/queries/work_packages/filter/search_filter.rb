#-- encoding: UTF-8



class Queries::WorkPackages::Filter::SearchFilter <
  Queries::WorkPackages::Filter::WorkPackageFilter
  include Queries::WorkPackages::Filter::OrFilterForWpMixin

  CONTAINS_OPERATOR = '~'.freeze

  CE_FILTERS = [
    Queries::WorkPackages::Filter::FilterConfiguration.new(
      Queries::WorkPackages::Filter::SubjectFilter,
      :subject,
      CONTAINS_OPERATOR
    ),
    Queries::WorkPackages::Filter::FilterConfiguration.new(
      Queries::WorkPackages::Filter::DescriptionFilter,
      :subject,
      CONTAINS_OPERATOR
    ),
    Queries::WorkPackages::Filter::FilterConfiguration.new(
      Queries::WorkPackages::Filter::CommentFilter,
      :subject,
      CONTAINS_OPERATOR
    )
  ].freeze

  EE_TSV_FILTERS = [
    Queries::WorkPackages::Filter::FilterConfiguration.new(
      Queries::WorkPackages::Filter::AttachmentContentFilter,
      :subject,
      CONTAINS_OPERATOR
    ),
    Queries::WorkPackages::Filter::FilterConfiguration.new(
      Queries::WorkPackages::Filter::AttachmentFileNameFilter,
      :subject,
      CONTAINS_OPERATOR
    )
  ].freeze

  def type
    :search
  end

  def human_name
    I18n.t('label_search')
  end

  def custom_field_configurations
    custom_fields =
      if context&.project
        context.project.all_work_package_custom_fields.select do |custom_field|
          %w(text string).include?(custom_field.field_format) &&
            custom_field.is_filter == true &&
            custom_field.searchable == true
        end
      else
        ::WorkPackageCustomField
          .filter
          .for_all
          .where(field_format: %w(text string),
                 is_filter: true,
                 searchable: true)
      end

    custom_fields.map do |custom_field|
      Queries::WorkPackages::Filter::FilterConfiguration.new(
        Queries::WorkPackages::Filter::CustomFieldFilter,
        "cf_#{custom_field.id}",
        CONTAINS_OPERATOR
      )
    end
  end

  def filter_configurations
    list = CE_FILTERS

    list += custom_field_configurations
    list += EE_TSV_FILTERS if attachment_filters_allowed?
    list
  end

  private

  def attachment_filters_allowed?
    EnterpriseToken.allows_to?(:attachment_filters) && ProyeksiApp::Database.allows_tsv?
  end
end
