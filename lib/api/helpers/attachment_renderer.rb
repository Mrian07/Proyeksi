#-- encoding: UTF-8

##
# Attachment helper to be included into endpoints
module API
  module Helpers
    module AttachmentRenderer
      def self.content_endpoint(&block)
        ->(*) {
          helpers ::API::Helpers::AttachmentRenderer

          finally do
            set_cache_headers
          end

          get do
            attachment = instance_exec(&block)
            respond_with_attachment attachment, cache_seconds: fog_cache_seconds
          end
        }
      end

      ##
      # Render an attachment, either by redirecting
      # to the external storage,
      #
      # or by directly rendering the file
      #
      # @param attachment [Attachment] Attachment to be responded with.
      # @param cache_seconds [integer] Time in seconds the cache headers signal the browser to cache the attachment.
      #                                Defaults to no cache headers.
      def respond_with_attachment(attachment, cache_seconds: nil)
        prepare_cache_headers(cache_seconds) if cache_seconds

        if attachment.external_storage?
          redirect_to_external_attachment(attachment, cache_seconds)
        else
          send_attachment(attachment)
        end
      end

      private

      def redirect_to_external_attachment(attachment, cache_seconds)
        set_cache_headers!
        redirect attachment.external_url(expires_in: cache_seconds).to_s
      end

      def send_attachment(attachment)
        content_type attachment.content_type
        header['Content-Disposition'] = attachment.content_disposition
        env['api.format'] = :binary
        sendfile attachment.diskfile.path
      end

      def set_cache_headers
        set_cache_headers! if @stream
      end

      def prepare_cache_headers(seconds)
        @prepared_cache_headers = { "Cache-Control" => "public, max-age=#{seconds}",
                                    "Expires" => CGI.rfc1123_date(Time.now.utc + seconds) }
      end

      def set_cache_headers!(seconds = nil)
        prepare_cache_headers(seconds) if seconds

        (@prepared_cache_headers || {}).each do |key, value|
          header key, value
        end
      end

      def fog_cache_seconds
        [
          0,
          ProyeksiApp::Configuration.fog_download_url_expires_in.to_i - 10
        ].max
      end

      def avatar_link_expires_in
        seconds = avatar_link_expiry_seconds

        if seconds == 0
          nil
        else
          seconds.seconds
        end
      end

      def avatar_link_expiry_seconds
        @avatar_link_expiry_seconds ||= ProyeksiApp::Configuration.avatar_link_expiry_seconds.to_i
      end
    end
  end
end
