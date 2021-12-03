#-- encoding: UTF-8



class Journal < ApplicationRecord
  self.table_name = 'journals'

  include ::JournalChanges
  include ::JournalFormatter
  include ::Acts::Journalized::FormatHooks

  register_journal_formatter :diff, ProyeksiApp::JournalFormatter::Diff
  register_journal_formatter :attachment, ProyeksiApp::JournalFormatter::Attachment
  register_journal_formatter :custom_field, ProyeksiApp::JournalFormatter::CustomField
  register_journal_formatter :schedule_manually, ProyeksiApp::JournalFormatter::ScheduleManually

  # Make sure each journaled model instance only has unique version ids
  validates_uniqueness_of :version, scope: %i[journable_id journable_type]

  belongs_to :user
  belongs_to :journable, polymorphic: true
  belongs_to :data, polymorphic: true, dependent: :destroy

  has_many :attachable_journals, class_name: 'Journal::AttachableJournal', dependent: :destroy
  has_many :customizable_journals, class_name: 'Journal::CustomizableJournal', dependent: :destroy

  has_many :notifications, dependent: :destroy

  # Scopes to all journals excluding the initial journal - useful for change
  # logs like the history on issue#show
  scope :changing, -> { where(['version > 1']) }

  # In conjunction with the included Comparable module, allows comparison of journal records
  # based on their corresponding version numbers, creation timestamps and IDs.
  def <=>(other)
    [version, created_at, id].map(&:to_i) <=> [other.version, other.created_at, other.id].map(&:to_i)
  end

  # Returns whether the version has a version number of 1. Useful when deciding whether to ignore
  # the version during reversion, as initial versions have no serialized changes attached. Helps
  # maintain backwards compatibility.
  def initial?
    version < 2
  end

  # The anchor number for html output
  def anchor
    version - 1
  end

  # Possible shortcut to the associated project
  def project
    if journable.respond_to?(:project)
      journable.project
    elsif journable.is_a? Project
      journable
    end
  end

  def editable_by?(user)
    journable.journal_editable_by?(self, user)
  end

  def details
    get_changes
  end

  def new_value_for(prop)
    details[prop].last if details.keys.include? prop
  end

  def old_value_for(prop)
    details[prop].first if details.keys.include? prop
  end

  def previous
    predecessor
  end

  def noop?
    (!notes || notes&.empty?) && get_changes.empty?
  end

  private

  def predecessor
    @predecessor ||= if initial?
                       nil
                     else
                       self.class
                         .where(journable_type: journable_type, journable_id: journable_id)
                         .where("#{self.class.table_name}.version < ?", version)
                         .order(version: :desc)
                         .first
                     end
  end
end
