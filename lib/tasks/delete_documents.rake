#-- encoding: UTF-8



require_relative 'shared/user_feedback'

namespace :migrations do
  namespace :documents do
    include Tasks::Shared::UserFeedback

    class TemporaryDocument < ActiveRecord::Base
      belongs_to :project
      belongs_to :category, class_name: 'DocumentCategory', foreign_key: 'category_id'
    end

    desc 'Removes all documents'
    task delete: :environment do |_task|
      try_delete_documents
    end

    def try_delete_documents
      if !$stdout.isatty || user_agrees_to_delete_all_documents
        puts 'Delete all attachments attached to projects or versions...'

        TemporaryDocument.destroy_all
        Attachment.where(container_type: ['Document']).destroy_all
      end
    rescue StandardError
      raise 'Cannot delete documents! There may be migrations missing...?'
    end

    def user_agrees_to_delete_all_documents
      questions = ['CAUTION: This rake task will delete ALL documents!',
                   "DISCLAIMER: This is the final warning: You're going to lose information!"]

      ask_for_confirmation(questions)
    end
  end
end
