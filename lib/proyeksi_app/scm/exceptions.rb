#-- encoding: UTF-8


module ProyeksiApp
  module SCM
    module Exceptions
      # Parent SCM exception class
      class SCMError < StandardError
      end

      # Exception marking an error in the repository build process
      class RepositoryBuildError < SCMError
      end

      # Exception marking an error in the repository teardown process
      class RepositoryUnlinkError < SCMError
      end

      # Exception marking an error in the execution of a local command.
      class CommandFailed < SCMError
        attr_reader :program, :message, :stderr

        # Create a +CommandFailed+ exception for the executed program (e.g., 'svn'),
        # and a meaningful error message
        #
        # If the operation throws an exception or the operation we rethrow a
        # +ShellError+ with a meaningful error message.
        def initialize(program, message, stderr = nil)
          @program = program
          @message = message
          @stderr  = stderr
        end

        def to_s
          s = "CommandFailed(#{@program}) -> #{@message}"
          s << "(#{@stderr})" unless @stderr.nil?

          s
        end
      end

      # a localized exception raised when SCM could be accessed
      class SCMUnavailable < SCMError
        def initialize(key = 'unavailable')
          @error = I18n.t("repositories.errors.#{key}")
        end

        def to_s
          @error
        end
      end

      # raised if SCM could not be accessed due to authorization failure
      class SCMUnauthorized < SCMUnavailable
        def initialize
          super('unauthorized')
        end
      end

      # raised when encountering an empty (bare) repository
      class SCMEmpty < SCMUnavailable
        def initialize
          super('empty_repository')
        end
      end
    end
  end
end
