#-- encoding: UTF-8



module Projects::Copy
  class WikiPageAttachmentsDependentService < Dependency
    include ::Copy::Concerns::CopyAttachments

    def self.human_name
      I18n.t(:label_wiki_page_attachments)
    end

    def source_count
      source.wiki && source.wiki.pages.joins(:attachments).count('attachments.id')
    end

    protected

    def copy_dependency(params:)
      # If no wiki pages copied, we cannot copy their attachments
      return unless state.wiki_page_id_lookup

      state.wiki_page_id_lookup.each do |old_id, new_id|
        copy_attachments('WikiPage', from_id: old_id, to_id: new_id)
      end
    end
  end
end
