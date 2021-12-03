

require_dependency 'work_package'

module ProyeksiApp::Backlogs::Patches::WorkPackagePatch
  extend ActiveSupport::Concern

  included do
    prepend InstanceMethods
    extend ClassMethods

    before_validation :backlogs_before_validation, if: lambda { backlogs_enabled? }

    register_on_journal_formatter(:fraction, 'remaining_hours')
    register_on_journal_formatter(:decimal, 'story_points')
    register_on_journal_formatter(:decimal, 'position')

    validates_numericality_of :story_points, only_integer: true,
                                             allow_nil: true,
                                             greater_than_or_equal_to: 0,
                                             less_than: 10_000,
                                             if: lambda { backlogs_enabled? }

    validates_numericality_of :remaining_hours, only_integer: false,
                                                allow_nil: true,
                                                greater_than_or_equal_to: 0,
                                                if: lambda { backlogs_enabled? }

    include ProyeksiApp::Backlogs::List
  end

  module ClassMethods
    def backlogs_types
      # Unfortunately, this is not cachable so the following line would be wrong
      # @backlogs_types ||= Story.types << Task.type
      # Caching like in the line above would prevent the types selected
      # for backlogs to be changed without restarting all app server.
      (Story.types << Task.type).compact
    end

    def children_of(ids)
      includes(:parent_relation)
        .where(relations: { from_id: ids })
    end

    # Prevent problems with subclasses of WorkPackage
    # not having a TypedDag configuration
    def _dag_options
      TypedDag::Configuration[WorkPackage]
    end
  end

  module InstanceMethods
    def done?
      project.done_statuses.to_a.include?(status)
    end

    def to_story
      Story.find(id) if is_story?
    end

    def is_story?
      backlogs_enabled? && Story.types.include?(type_id)
    end

    def to_task
      Task.find(id) if is_task?
    end

    def is_task?
      backlogs_enabled? && (parent_id && type_id == Task.type && Task.type.present?)
    end

    def is_impediment?
      backlogs_enabled? && (parent_id.nil? && type_id == Task.type && Task.type.present?)
    end

    def types
      if is_story?
        Story.types
      elsif is_task?
        Task.types
      else
        []
      end
    end

    def story
      if is_story?
        Story.find(id)
      elsif is_task?
        # Make sure to get the closest ancestor that is a Story
        ancestors_relations
          .includes(:from)
          .where(from: { type_id: Story.types })
          .order(hierarchy: :asc)
          .first
          .from
      end
    end

    def blocks
      # return work_packages that I block that aren't closed
      return [] if closed?

      blocks_relations.includes(:to).merge(WorkPackage.with_status_open).map(&:to)
    end

    def blockers
      # return work_packages that block me
      return [] if closed?

      blocked_by_relations.includes(:from).merge(WorkPackage.with_status_open).map(&:from)
    end

    def backlogs_enabled?
      !!project.try(:module_enabled?, 'backlogs')
    end

    def in_backlogs_type?
      backlogs_enabled? && WorkPackage.backlogs_types.include?(type.try(:id))
    end

    private

    def backlogs_before_validation
      if type_id == Task.type
        self.estimated_hours = remaining_hours if estimated_hours.blank? && !remaining_hours.blank?
        self.remaining_hours = estimated_hours if remaining_hours.blank? && !estimated_hours.blank?
      end
    end
  end
end

WorkPackage.include ProyeksiApp::Backlogs::Patches::WorkPackagePatch