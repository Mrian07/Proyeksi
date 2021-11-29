#-- encoding: UTF-8



module OpenProject
  module SCM
    module Adapters
      module CheckoutInstructions
        ##
        # Returns the checkout URL for the given repository
        # based on this adapter's knowledge
        def checkout_url(repository, base_url, path)
          checkout_url = if local?
                           ::URI.join(with_trailing_slash(base_url),
                                      repository.repository_identifier)
                         else
                           url
                         end

          if subtree_checkout? && path.present?
            ::URI.join(with_trailing_slash(checkout_url), path)
          else
            checkout_url
          end
        end

        ##
        # Returns whether the SCM vendor supports subtree checkout
        def subtree_checkout?
          false
        end

        ##
        # Returns the checkout command for this vendor
        def checkout_command
          raise NotImplementedError
        end

        private

        ##
        # Ensure URL has a trailing slash.
        # Needed for base URL, because URI.join will otherwise
        # assume a relative resource.
        def with_trailing_slash(url)
          url = url.to_s

          url << '/' unless url.end_with?('/')
          url
        end
      end
    end
  end
end
