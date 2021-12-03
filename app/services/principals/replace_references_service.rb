#-- encoding: UTF-8

# Rewrites references to a principal from one principal to the other.
# No data is to be removed.
module Principals
  class ReplaceReferencesService
    def call(from:, to:)
      rewrite_active_models(from, to)
      rewrite_custom_value(from, to)
      rewrite_default_journals(from, to)
      rewrite_customizable_journals(from, to)

      ServiceResult.new success: true
    end

    private

    # rubocop:disable Rails/SkipsModelValidations
    def rewrite_active_models(from, to)
      rewrite_author(from, to)
      rewrite_user(from, to)
      rewrite_assigned_to(from, to)
      rewrite_responsible(from, to)
      rewrite_actor(from, to)
    end

    def rewrite_custom_value(from, to)
      CustomValue
        .where(custom_field_id: CustomField.where(field_format: 'user'))
        .where(value: from.id.to_s)
        .update_all(value: to.id.to_s)
    end

    def rewrite_default_journals(from, to)
      journal_classes.each do |klass|
        foreign_keys.each do |foreign_key|
          if klass.column_names.include? foreign_key
            klass
              .where(foreign_key => from.id)
              .update_all(foreign_key => to.id)
          end
        end
      end
    end

    def rewrite_customizable_journals(from, to)
      Journal::CustomizableJournal
        .joins(:custom_field)
        .where(custom_fields: { field_format: 'user' })
        .where(value: from.id.to_s)
        .update_all(value: to.id.to_s)
    end

    def rewrite_author(from, to)
      [WorkPackage,
       Attachment,
       WikiContent,
       News,
       Comment,
       Message,
       Budget,
       MeetingAgenda,
       MeetingMinutes].each do |klass|
        klass.where(author_id: from.id).update_all(author_id: to.id)
      end
    end

    def rewrite_user(from, to)
      [TimeEntry,
       ::Query,
       Changeset,
       CostQuery,
       MeetingParticipant].each do |klass|
        klass.where(user_id: from.id).update_all(user_id: to.id)
      end
    end

    def rewrite_actor(from, to)
      [::Notification].each do |klass|
        klass.where(actor_id: from.id).update_all(actor_id: to.id)
      end
    end

    def rewrite_assigned_to(from, to)
      [WorkPackage].each do |klass|
        klass.where(assigned_to_id: from.id).update_all(assigned_to_id: to.id)
      end
    end

    def rewrite_responsible(from, to)
      [WorkPackage].each do |klass|
        klass.where(responsible_id: from.id).update_all(responsible_id: to.id)
      end
    end

    # rubocop:enable Rails/SkipsModelValidations

    def journal_classes
      [Journal] + Journal::BaseJournal.subclasses
    end

    def foreign_keys
      %w[author_id user_id assigned_to_id responsible_id]
    end
  end
end
