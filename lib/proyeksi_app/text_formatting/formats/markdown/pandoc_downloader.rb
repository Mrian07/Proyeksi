#-- encoding: UTF-8



require 'open3'
require 'fileutils'
require 'rest-client'

module ProyeksiApp::TextFormatting::Formats
  module Markdown
    module PandocDownloader
      class << self
        def check_or_download!
          # Return if we have another version defined in ENV
          if forced_pandoc_path
            return compatible? forced_pandoc_path,
                               "Environment variable PROYEKSIAPP_PANDOC_PATH set, but version is not executable by ProyeksiApp or incompatible."
          end

          # Return if we have a compatible version
          return if compatible?

          warn <<~INFO
            You have no compatible (>= 2.0) of pandoc in path. We're now trying to download a recent version for your amd64 linux
            from '#{pandoc_amd64_tar}' to '#{vendored_pandoc_dir}'.

            For more information, please visit this page: https://www.proyeksiapp.org/textile-to-markdown-migration
          INFO

          download!

          raise "Failed to download pandoc version" unless compatible?
        rescue StandardError => e
          warn <<~WARNING
            Error occurred while trying to find / download compatible pandoc version for your system:

            #{e.message}
          WARNING
        end

        ##
        # Check if the given pandoc version is compatible
        # Returns true/false
        # Raises raise_msg if set and incompatible
        def compatible?(path = pandoc_path, raise_msg = nil)
          stdout, _, status = Open3.capture3(path, '--version')

          if !status.success? && raise_msg.present?
            raise raise_msg
          end

          status.success? && stdout.match(/^pandoc [23]\./i)
        rescue StandardError => e
          if raise_msg.present?
            raise raise_msg
          end

          false
        end

        def forced_pandoc_path
          ENV['PROYEKSIAPP_PANDOC_PATH']
        end

        def pandoc_path
          vendored = Rails.root.join('vendor/pandoc/bin/pandoc').to_s

          # Always return the vendored path if we have installed one
          return vendored if File.executable?(vendored)

          ENV.fetch('PROYEKSIAPP_PANDOC_PATH', 'pandoc')
        end

        def vendored_pandoc_dir
          Rails.root.join('vendor/pandoc').to_s
        end

        def pandoc_amd64_tar
          ENV.fetch('PROYEKSIAPP_PANDOC_TAR_DOWNLOAD', 'https://github.com/jgm/pandoc/releases/download/2.2.3.2/pandoc-2.2.3.2-linux.tar.gz')
        end

        private

        def download!
          response = RestClient::Request.execute method: :get,
                                                 url: pandoc_amd64_tar,
                                                 raw_response: true
          tempfile = response.file

          # Create vendor dir, this will however usually exist already
          FileUtils.mkdir_p vendored_pandoc_dir

          begin
            # Extract downloaded tar into vendor
            _, stderr_str, status = Open3.capture3('tar', 'xvzf', tempfile.path.to_s,
                                                   '--strip-components', '1', '-C', vendored_pandoc_dir)
            raise stderr_str unless status.success?
          ensure
            tempfile.unlink
          end
        end
      end
    end
  end
end
