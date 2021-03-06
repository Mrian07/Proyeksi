#-- encoding: UTF-8

#
module Query::Timelines
  extend ActiveSupport::Concern

  included do
    enum timeline_zoom_level: %i(days weeks months quarters years auto)
    validates :timeline_zoom_level, inclusion: { in: timeline_zoom_levels.keys }

    serialize :timeline_labels, Hash
    validate :valid_timeline_labels

    def valid_timeline_labels
      return unless timeline_labels.present?

      valid_keys = %w(farRight left right) == timeline_labels.keys.map(&:to_s).sort
      errors.add :timeline_labels, :invalid unless valid_keys
    end
  end
end
