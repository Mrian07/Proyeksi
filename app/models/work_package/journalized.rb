#-- encoding: UTF-8

module WorkPackage::Journalized
  extend ActiveSupport::Concern

  included do
    acts_as_journalized data_sql: ->(journable) do
      <<~SQL
        LEFT OUTER JOIN
          (
            #{Relation.hierarchy.direct.where(to_id: journable.id).limit(1).select('from_id parent_id, to_id').to_sql}
          ) parent_relation
        ON
          #{journable.class.table_name}.id = parent_relation.to_id
      SQL
    end

    # This one is here only to ease reading
    module JournalizedProcs
      def self.event_title
        Proc.new do |o|
          title = o.to_s
          title << " (#{o.status.name})" if o.status.present?

          title
        end
      end

      def self.event_name
        Proc.new do |o|
          I18n.t(o.event_type.underscore, scope: 'events')
        end
      end

      def self.event_type
        Proc.new do |o|
          journal = o.last_journal
          t = 'work_package'

          t << if journal && journal.details.empty? && !journal.initial?
                 '-note'
               else
                 status = Status.find_by(id: o.status_id)

                 status.try(:is_closed?) ? '-closed' : '-edit'
               end
          t
        end
      end

      def self.event_url
        Proc.new do |o|
          { controller: :work_packages, action: :show, id: o.id }
        end
      end
    end

    acts_as_event title: JournalizedProcs.event_title,
                  type: JournalizedProcs.event_type,
                  name: JournalizedProcs.event_name,
                  url: JournalizedProcs.event_url

    register_journal_formatter(:cost_association) do |value, journable, field|
      association = journable.class.reflect_on_association(field.to_sym)
      if association
        record = association.class_name.constantize.find_by_id(value.to_i)
        record&.subject
      end
    end

    register_on_journal_formatter(:id, 'parent_id')
    register_on_journal_formatter(:fraction, 'estimated_hours')
    register_on_journal_formatter(:fraction, 'derived_estimated_hours')
    register_on_journal_formatter(:decimal, 'done_ratio')
    register_on_journal_formatter(:diff, 'description')
    register_on_journal_formatter(:schedule_manually, 'schedule_manually')
    register_on_journal_formatter(:attachment, /attachments_?\d+/)
    register_on_journal_formatter(:custom_field, /custom_fields_\d+/)
    register_on_journal_formatter(:cost_association, 'budget_id')

    # Joined
    register_on_journal_formatter :named_association, :parent_id, :project_id,
                                  :status_id, :type_id,
                                  :assigned_to_id, :priority_id,
                                  :category_id, :version_id,
                                  :author_id, :responsible_id
    register_on_journal_formatter :datetime, :start_date, :due_date
    register_on_journal_formatter :plaintext, :subject
  end
end
