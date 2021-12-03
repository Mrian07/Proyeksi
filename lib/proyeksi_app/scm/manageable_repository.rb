#-- encoding: UTF-8



module ProyeksiApp
  module SCM
    module ManageableRepository
      def self.included(base)
        base.extend(ClassMethods)

        ##
        # Take note when projects are renamed and check for associated managed repositories
        ProyeksiApp::Notifications.subscribe('project_renamed') do |payload|
          repository = payload[:project].repository

          if repository&.managed?
            ::SCM::RelocateRepositoryJob.perform_later(repository)
          end
        end
      end

      module ClassMethods
        ##
        # We let SCM vendor implementation define their own
        # types (e.g., for differences in the management of
        # local vs. remote repositories).
        #
        # But if they are manageable by ProyeksiApp, they must
        # expose this type through +available_types+.
        def managed_type
          :managed
        end

        ##
        # Reads from configuration whether new repositories of this kind
        # may be managed from ProyeksiApp.
        def manageable?
          !(disabled_types.include?(managed_type) || managed_root.nil?)
        end

        ##
        # Returns the managed root for this repository vendor
        def managed_root
          scm_config[:manages]
        end

        ##
        # Returns the managed remote for this repository vendor,
        # if any. Use +manages_remote?+ to determine whether the configuration
        # specifies local or remote managed repositories.
        def managed_remote
          URI.parse(scm_config[:manages])
        rescue URI::Error
          nil
        end

        ##
        # Returns whether the managed root is a remote URL to post to
        def manages_remote?
          managed_remote.present? && managed_remote.absolute?
        end
      end

      def manageable?
        self.class.manageable?
      end

      ##
      # Determines whether this repository IS currently managed
      # by proyeksiapp
      def managed?
        scm_type.to_sym == self.class.managed_type
      end

      ##
      # Allows descendants to perform actions
      # with the given repository after the managed
      # repository has been written to file system.
      def managed_repo_created(_args)
        nil
      end

      ##
      # Returns the absolute path to the repository
      # under the +managed_root+ path defined in the configuration
      # of this adapter.
      # Used only in the creation of a repository, at a later point
      # in time, it is referred to in the root_url
      def managed_repository_path
        File.join(self.class.managed_root, repository_identifier)
      end

      ##
      # Returns the access url to the repository
      # May be overridden by descendants
      # Used only in the creation of a repository, at a later point
      # in time, it is referred to in the url
      def managed_repository_url
        "file://#{managed_repository_path}"
      end

      ##
      # Repository relative path from scm managed root.
      # Will be overridden by including models to, e.g.,
      # append '.git' to that path.
      def repository_identifier
        project.identifier
      end
    end
  end
end
