#-- encoding: UTF-8



require 'rexml/document'
require 'open3'

module ProyeksiApp
  module VERSION #:nodoc:
    MAJOR = 12
    MINOR = 1
    PATCH = 0

    class << self
      # Used by semver to define the special version (if any).
      # A special version "satisfy but have a lower precedence than the associated
      # normal version". So 2.0.0RC1 would be part of the 2.0.0 series but
      # be considered to be an older version.
      #
      #   1.4.0 < 2.0.0RC1 < 2.0.0RC2 < 2.0.0 < 2.1.0
      #
      # This method may be overridden by third party code to provide vendor or
      # distribution specific versions. They may or may not follow semver.org:
      #
      #   2.0.0debian-2
      def special
        ''
      end

      def revision
        revision_from_core_version || revision_from_git
      end

      def product_version
        cached_or_block(:@product_version) do
          path = Rails.root.join('config', 'PRODUCT_VERSION')
          if File.exists? path
            File.read(path)
          end
        end
      end

      def core_version
        cached_or_block(:@core_version) do
          path = Rails.root.join('config', 'CORE_VERSION')
          if File.exists? path
            File.read(path)
          end
        end
      end

      ##
      # Get information on when this version was created / updated from either
      # 1. A RELEASE_DATE file
      # 2. From the git revision
      def updated_on
        release_date_from_file || release_date_from_git
      end

      def to_a; ARRAY end

      def to_s; STRING end

      def to_semver
        [MAJOR, MINOR, PATCH].join('.') + special
      end

      private

      def release_date_from_file
        cached_or_block(:@release_date_from_file) do
          path = Rails.root.join('config', 'RELEASE_DATE')
          if File.exists? path
            s = File.read(path)
            Date.parse(s)
          end
        end
      end

      def release_date_from_git
        cached_or_block(:@release_date_from_git) do
          date, = Open3.capture3('git', 'log', '-1', '--format=%cd', '--date=short')
          Date.parse(date) if date
        end
      end

      def revision_from_core_version
        return unless core_version.is_a?(String)

        core_version.split.first
      end

      def revision_from_git
        cached_or_block(:@revision) do
          revision, = Open3.capture3('git', 'rev-parse', 'HEAD')
          if revision.present?
            revision.strip[0..8]
          end
        end
      end

      def cached_or_block(variable)
        return instance_variable_get(variable) if instance_variable_defined?(variable)

        value = begin
          yield
        rescue StandardError
          nil
        end

        instance_variable_set(variable, value)
      end
    end

    REVISION = revision
    ARRAY = [MAJOR, MINOR, PATCH, REVISION].compact
    STRING = ARRAY.join('.')
  end
end
