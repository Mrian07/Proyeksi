#-- encoding: UTF-8



require 'sys/filesystem'
module OpenProject
  module Storage
    class << self
      ##
      # List available storage endpoints
      def mount_information
        return {} unless OpenProject::Configuration.show_storage_information?

        list_mounts(known_storage_paths)
      end

      ##
      # List available storage paths of OpenProject
      def known_storage_paths
        paths = {}

        # SCM vendors
        OpenProject::SCM::Manager.managed_paths.each do |vendor, path|
          paths[vendor] = {
            path: path,
            label: I18n.t(:label_managed_repositories_vendor, vendor: vendor.to_s.camelize)
          }
        end

        # Attachments
        paths[:attachments] = {
          path: OpenProject::Configuration.attachments_storage_path.to_s,
          label: I18n.t('attributes.attachments')
        }

        paths
      end

      private

      ##
      # Return mount information based on their filesystem id
      #
      def list_mounts(entries)
        mounts = {}

        entries.each do |_identifier, entry|
          stat = read_fs_info(entry[:path])
          next if stat.nil?

          # Aggregate directories by filesystem, so we don't return
          # storage information from the same filesystem twice
          fs_id = stat[:id]
          if mounts[fs_id].nil?
            mounts[fs_id] = { labels: [entry[:label]], data: stat }
          else
            mounts[fs_id][:labels] << entry[:label]
          end
        end

        mounts
      end

      def read_fs_info(dir)
        return nil unless File.directory?(dir)

        stat = Sys::Filesystem.stat(dir)

        {
          dir: dir,
          free: stat.bytes_free,
          used: stat.bytes_used,
          percent_used: stat.percent_used,
          total: stat.bytes_total,
          id: stat.filesystem_id
        }
      rescue SystemCallError, Sys::Filesystem::Error => e
        Rails.logger.warn("Can't read storage information on #{dir}: #{e.message}")

        nil
      end
    end
  end
end
