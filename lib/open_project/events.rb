

module OpenProject
  ##
  # Events defined in OpenProject, e.g. created work packages.
  # The module defines a constant for each event.
  #
  # Plugins should register their events here too by prepending a module
  # including the respective constants.
  #
  # @note Does not include all events but it should!
  # @see OpenProject::Notifications
  module Events
    AGGREGATED_WORK_PACKAGE_JOURNAL_READY = "aggregated_work_package_journal_ready".freeze
    AGGREGATED_WIKI_JOURNAL_READY = "aggregated_wiki_journal_ready".freeze
    AGGREGATED_NEWS_JOURNAL_READY = "aggregated_news_journal_ready".freeze
    AGGREGATED_MESSAGE_JOURNAL_READY = "aggregated_message_journal_ready".freeze

    ATTACHMENT_CREATED = 'attachment_created'.freeze

    JOURNAL_CREATED = 'journal_created'.freeze
    JOURNAL_AGGREGATE_BEFORE_DESTROY = 'journal_aggregate_before_destroy'.freeze

    MEMBER_CREATED = 'member_created'.freeze
    MEMBER_UPDATED = 'member_updated'.freeze
    # Called like this for historic reasons, should be called 'member_destroyed'
    MEMBER_DESTROYED = 'member_removed'.freeze

    TIME_ENTRY_CREATED = "time_entry_created".freeze

    NEWS_COMMENT_CREATED = "news_comment_created".freeze

    PROJECT_CREATED = "project_created".freeze
    PROJECT_UPDATED = "project_updated".freeze
    PROJECT_RENAMED = "project_renamed".freeze

    WATCHER_ADDED = 'watcher_added'.freeze
    WATCHER_REMOVED = 'watcher_removed'.freeze
  end
end
