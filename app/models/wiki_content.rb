#-- encoding: UTF-8



class WikiContent < ApplicationRecord
  extend DeprecatedAlias

  belongs_to :page, class_name: 'WikiPage'
  belongs_to :author, class_name: 'User'

  acts_as_journalized

  acts_as_event type: 'wiki-page',
                title: Proc.new { |o|
                  "#{I18n.t(:label_wiki_edit)}: #{o.journal.journable.page.title} (##{o.journal.journable.version})"
                },
                url: Proc.new { |o|
                  {
                    controller: '/wiki',
                    action: 'show',
                    id: o.journal.journable.page,
                    project_id: o.journal.journable.page.wiki.project,
                    version: o.journal.journable.version
                  }
                }

  def activity_type
    'wiki_edits'
  end

  def visible?(user = User.current)
    page.visible?(user)
  end

  delegate :project, to: :page

  def attachments
    page.nil? ? [] : page.attachments
  end

  def text=(value)
    super value.presence || ''
  end

  deprecated_alias :versions, :journals

  def version
    last_journal.nil? ? 0 : last_journal.version
  end
end
