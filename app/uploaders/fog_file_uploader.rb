require 'carrierwave/storage/fog'

class FogFileUploader < CarrierWave::Uploader::Base
  include FileUploader
  storage :fog

  # Delete cache and old rack file after store
  # cf. https://github.com/carrierwaveuploader/carrierwave/wiki/How-to:-Delete-cache-garbage-directories

  before :store, :remember_cache_id
  after :store, :delete_tmp_dir
  after :store, :delete_old_tmp_file

  def copy_to(attachment)
    attachment.remote_file_url = remote_file.url
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def remote_file
    @remote_file || file
  end

  def local_file
    @remote_file ||= file
    cache_stored_file!
    super
  end

  ##
  # This is necessary for carrierwave to set the Content-Type in the S3 metadata for instance.
  def fog_attributes
    content_type = model.respond_to?(:content_type) ? model.content_type : ""

    return super if content_type.blank?

    super.merge "Content-Type": content_type
  end

  ##
  # Generates a download URL for this file.
  #
  # @param options [Hash] Options hash.
  # @option options [String] :content_disposition Pass this content disposition to S3 so that it serves the file with it.
  # @option options [DateTime] :expires_at Date at which the link should expire (default: now + 5 minutes)
  # @option options [ActiveSupport::Duration] :expires_in Duration in which the link should expire.
  #
  # @return [String] The URL to download the file from.
  def download_url(options = {})
    url_options = {}

    set_content_disposition! url_options, options: options
    set_expires_at! url_options, options: options

    remote_file.url url_options
  end

  ##
  # Checks if this file exists and is readable in the remote storage.
  #
  # In the current version of carrierwave the call to #exists?
  # throws an error if the file does not exist:
  #
  #   Excon::Errors::Forbidden: Expected(200) <=> Actual(403 Forbidden)
  def readable?
    remote_file&.exists?
  rescue Excon::Errors::Forbidden
    false
  end

  private

  def set_content_disposition!(url_options, options:)
    if options[:content_disposition].present?
      url_options[:query] = {
        # Passing this option to S3 will make it serve the file with the
        # respective content disposition. Without it no content disposition
        # header is sent. This only works for S3 but we don't support
        # anything else anyway (see carrierwave.rb).
        "response-content-disposition" => options[:content_disposition]
      }
    end
  end

  def set_expires_at!(url_options, options:)
    if options[:expires_in].present?
      expires = [options[:expires_in], ProyeksiApp::Configuration.fog_download_url_expires_in].min
      url_options[:expire_at] = ::Fog::Time.now + expires
    end

    if options[:expires_at].present?
      url_options[:expire_at] = ::Fog::Time.at options[:expires_at] - ::Fog::Time.offset
    end
  end
end
