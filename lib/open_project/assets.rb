#-- encoding: UTF-8


require 'fileutils'

module OpenProject
  module Assets
    class << self
      ##
      # Look up an asset in the manifest. If it does not exist,
      # return the chunk name itself.
      # Input: main.js
      # Output:
      #  - when in manifest: main.<hash>.js
      #  - when not in manifest: main.js
      def lookup_asset(unhashed_filename)
        name = unhashed_filename.to_s
        load_manifest.fetch(name, name)
      end

      def frontend_asset_path
        Rails.root.join('public/assets/frontend/')
      end

      def manifest_path
        Rails.root.join('config/frontend_assets.manifest.json')
      end

      def load_manifest
        @manifest ||= begin
          JSON.parse File.read(manifest_path)
        rescue StandardError => e
          Rails.logger.error "Failed to read frontend manifest file: #{e} #{e.message}."
          {}
        end
      end

      ##
      # Clear frontend asset path
      def clear!
        FileUtils.rm_rf frontend_asset_path
      end

      ##
      # Rebuilds the manifest file
      def rebuild_manifest!
        # Remove index html
        FileUtils.remove File.join(frontend_asset_path, 'index2.html'), force: true

        # Create map of asset chunk name to current hash
        manifest = {}
        OpenProject::Assets.current_assets.each do |filename|
          md = filename.match /\A([^.]+)\.(\w+)\.(\w+)\z/

          # Non-hashed asset
          next if md.nil?

          chunk_name = "#{md[1]}.#{md[3]}"
          manifest[chunk_name] = filename
        end

        File.open(manifest_path, 'w+') { |file| file.write manifest.to_json }
      end

      def current_assets
        Dir.glob(OpenProject::Assets.frontend_asset_path + '*')
          .select { |f| File.file? f }
          .map { |f| File.basename(f) }
      end
    end
  end
end
