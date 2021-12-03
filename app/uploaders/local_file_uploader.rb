

require 'fileutils'

class LocalFileUploader < CarrierWave::Uploader::Base
  include FileUploader
  storage :file

  # Delete cache and old rack file after store
  # cf. https://github.com/carrierwaveuploader/carrierwave/wiki/How-to:-Delete-cache-garbage-directories

  before :store, :remember_cache_id
  after :store, :delete_tmp_dir
  after :store, :delete_old_tmp_file

  def copy_to(attachment)
    attachment.file = local_file
  end

  def store_dir
    dir = "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    ProyeksiApp::Configuration.attachments_storage_path.join(dir)
  end
end
