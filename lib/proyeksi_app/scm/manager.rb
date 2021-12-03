#-- encoding: UTF-8



module ProyeksiApp
  module SCM
    class Manager
      class << self
        def registered
          @scms ||= {
            subversion: ::Repository::Subversion,
            git: ::Repository::Git
          }
        end

        ##
        # Returns a list of registered SCM vendor symbols
        # (e.g., :git, :subversion)
        def vendors
          @scms.keys
        end

        ##
        # Returns all enabled repositories as a Hash
        # { vendor_name: repository class constant }
        def enabled
          registered.select { |vendor, _| Setting.enabled_scm.include?(vendor.to_s) }
        end

        ##
        # Returns whether the particular vendor symbol
        # is available AND enabled through settings.
        def enabled?(vendor)
          enabled.include?(vendor)
        end

        # Return all manageable vendors
        def manageable
          registered.select { |_, klass| klass.manageable? }
        end

        ##
        # Return a hash of all managed paths for SCM vendors
        # { Vendor: <Path> }
        def managed_paths
          paths = {}
          registered.each do |vendor, klass|
            paths[vendor] = klass.managed_root if klass.manageable?
          end

          paths
        end

        # Add a new SCM adapter and repository
        def add(vendor)
          # Force model lookup to avoid
          # const errors later on.
          klass = Repository.const_get(vendor.to_s.camelize)
          registered[vendor] = klass
        end

        # Remove a SCM adapter from Redmine's list of supported scms
        def delete(vendor)
          registered.delete(vendor)
        end
      end
    end
  end
end
