#-- encoding: UTF-8



require_relative 'shared/user_feedback'

require 'tasks/shared/legacy_attachment'
require 'tasks/shared/attachment_migration'

module Migrations
  ##
  # We create a separate classes as this is most likely to be used during
  # the migration of an ChiliProject (2.x or 3.x) which lacks a couple
  # of columns models have in ProyeksiApp >6.
  module Attachments
    class CurrentWikiPage < ::ActiveRecord::Base
      self.table_name = "wiki_pages"

      has_one :content, class_name: 'WikiContent', foreign_key: 'page_id', dependent: :destroy
    end

    class CurrentWikiContent < ::ActiveRecord::Base
      self.table_name = "wiki_contents"
    end
  end
end

namespace :migrations do
  namespace :attachments do
    include ::Tasks::Shared::UserFeedback
    include ::Tasks::Shared::AttachmentMigration

    desc 'Removes all attachments from versions and projects'
    task delete_from_projects_and_versions: :environment do |_task|
      try_delete_attachments_from_projects_and_versions
    end

    desc 'Creates special wiki pages for each project and version moving the attachments there.'
    task move_to_wiki: :environment do |_task|
      Project.transaction do
        if Journal.count > 0
          raise(
            "Expected there to be no existing journals at this point before " +
            "the legacy journal migration. Aborting."
          )
        end

        move_obsolete_attachments_to_wiki!
      end
    end

    desc 'Moves old attachment files to their correct new path under carrierwave.'
    task move_old_files: :environment do |_task|
      count = Attachment.count

      puts "Migrating #{count} attachments to CarrierWave."
      puts 'Depending on your configuration this can take a while.
            Especially if files are uploaded to S3.'.squish

      Attachment.all.each_with_index do |attachment, i|
        puts "Migrating attachment #{i + 1}/#{count} (#{attachment.disk_filename})"
        Tasks::Shared::LegacyAttachment.migrate_attachment attachment
      end
    end
  end
end
