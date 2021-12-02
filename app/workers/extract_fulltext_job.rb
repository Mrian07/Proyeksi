#-- encoding: UTF-8



class ExtractFulltextJob < ApplicationJob
  queue_with_priority :low

  def perform(attachment_id)
    @attachment_id = attachment_id
    @attachment = nil
    @text = nil
    @file = nil
    @filename = nil
    @language = ProyeksiApp::Configuration.main_content_language

    return unless ProyeksiApp::Database.allows_tsv?
    return unless @attachment = find_attachment(attachment_id)

    init
    update
  ensure
    FileUtils.rm @file.path if delete_file?
  end

  private

  def init
    carrierwave_uploader = @attachment.file
    @file = carrierwave_uploader.local_file
    @filename = carrierwave_uploader.file.filename

    if @attachment.readable?
      resolver = Plaintext::Resolver.new(@file, @attachment.content_type)
      @text = resolver.text
    end
  rescue StandardError => e
    Rails.logger.error(
      "Failed to extract plaintext from file #{@attachment&.id} (On domain #{Setting.host_name}): #{e}: #{e.message}"
    )
  end

  def update
    Attachment
      .where(id: @attachment_id)
      .update_all(['fulltext = ?, fulltext_tsv = to_tsvector(?, ?), file_tsv = to_tsvector(?, ?)',
                   @text,
                   @language,
                   ProyeksiApp::FullTextSearch.normalize_text(@text),
                   @language,
                   ProyeksiApp::FullTextSearch.normalize_filename(@filename)])
  rescue StandardError => e
    Rails.logger.error(
      "Failed to update TSV values for attachment #{@attachment&.id} (On domain #{Setting.host_name}): #{e.message[0..499]}[...]"
    )
  end

  def find_attachment(id)
    Attachment.find_by(id: id)
  end

  def remote_file?
    !@attachment&.file.is_a?(LocalFileUploader)
  end

  def delete_file?
    remote_file? && @file
  end
end
