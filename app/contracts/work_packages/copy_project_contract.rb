

require 'work_packages/create_contract'

# Can be used to copy all of a project's work packages. As the
# work packages can be old, some of the validations that would
# apply to newly created work packages need not apply there, e.g
# on copying, it is ok for work packages to have closed versions
module WorkPackages
  class CopyProjectContract < CreateContract
    include WorkPackages::SkipAuthorizationChecks

    # let the contract be used in error messages
    delegate :to_s,
             to: :model

    private

    def validate_version_is_assignable; end

    def validate_no_reopen_on_closed_version; end
  end
end
