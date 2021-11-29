#-- encoding: UTF-8



##
# Implements a repository factory for building temporary and permanent repositories.
class SCM::RepositoryFactoryService
  attr_reader :project, :params, :repository

  def initialize(project, params)
    @project = project
    @params = params
  end

  ##
  # Build a full repository from a given scm_type
  # and persists it.
  #
  # @return [Boolean] true iff the repository was built
  def build_and_save
    build_guarded do
      repository = build_with_type(params.fetch(:scm_type).to_sym)
      if repository.save
        repository
      else
        raise OpenProject::SCM::Exceptions::RepositoryBuildError.new(
          repository.errors.full_messages.join("\n")
        )
      end
    end
  end

  ##
  # Build a temporary repository used only for determining available settings and types
  # of that particular vendor.
  #
  # @return [Boolean] true iff the repository was built
  def build_temporary
    build_guarded do
      build_with_type(nil)
    end
  end

  def build_error
    I18n.t('repositories.errors.build_failed', reason: @build_failed_msg)
  end

  private

  ##
  # Helper to actually build the repository and return it.
  # May raise +OpenProject::SCM::Exceptions::RepositoryBuildError+ internally.
  #
  # @param [Symbol] scm_type Type to build the repository with. May be nil
  #                          during temporary build
  def build_with_type(scm_type)
    Repository.build(
      project,
      params.fetch(:scm_vendor).to_sym,
      params.fetch(:repository, {}),
      scm_type
    )
  end

  def build_guarded
    @repository = yield
    @repository.present?
  rescue OpenProject::SCM::Exceptions::RepositoryBuildError => e
    @build_failed_msg = e.message
    nil
  end
end
