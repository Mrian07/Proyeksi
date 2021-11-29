#-- encoding: UTF-8



require 'open_project/scm/adapters/subversion'

class Repository::Subversion < Repository
  validates_presence_of :url
  validates_format_of :url, with: /\A(http|https|svn(\+[^\s:\/\\]+)?|file):\/\/.+\z/i

  def self.scm_adapter_class
    OpenProject::SCM::Adapters::Subversion
  end

  def configure(scm_type, _args)
    if scm_type == self.class.managed_type
      unless manageable?
        raise OpenProject::SCM::Exceptions::RepositoryBuildError.new(
          I18n.t('repositories.managed.error_not_manageable')
        )
      end

      self.root_url = managed_repository_path
      self.url = managed_repository_url
    end
  end

  def self.authorization_policy
    ::SCM::SubversionAuthorizationPolicy
  end

  def self.permitted_params(params)
    super(params).merge(params.permit(:login, :password))
  end

  def self.supported_types
    types = [:existing]
    types << managed_type if manageable?

    types
  end

  def managed_repo_created
    scm.create_empty_svn
  end

  def repository_type
    'Subversion'
  end

  def supports_directory_revisions?
    true
  end

  def repo_log_encoding
    'UTF-8'
  end

  def latest_changesets(path, rev, limit = 10)
    revisions = scm.revisions(path, rev, nil, limit: limit)
    revisions ? changesets.where(revision: revisions.map(&:identifier)).order(Arel.sql('committed_on DESC')).includes(:user) : []
  end

  # Returns a path relative to the url of the repository
  def relative_path(path)
    path.gsub(Regexp.new("^\/?#{Regexp.escape(relative_url)}\/"), '')
  end

  def fetch_changesets
    scm_info = scm.info
    if scm_info
      # latest revision found in database, may be nil
      db_revision = latest_changeset&.revision&.to_i

      # first revision to fetch
      identifier_from = db_revision ? db_revision + 1 : scm.start_revision

      # latest revision in the repository
      scm_revision = scm_info.lastrev.identifier.to_i
      if db_revision.nil? || db_revision < scm_revision
        Rails.logger.debug { "Fetching changesets for repository #{url}" }
        while identifier_from <= scm_revision
          # loads changesets by batches of 200
          identifier_to = [identifier_from + 199, scm_revision].min
          revisions = scm.revisions('', identifier_to, identifier_from, with_paths: true)
          unless revisions.nil?
            revisions.reverse_each do |revision|
              transaction do
                changeset = Changeset.create(repository: self,
                                             revision: revision.identifier,
                                             committer: revision.author,
                                             committed_on: revision.time,
                                             comments: revision.message)

                unless changeset.new_record?
                  revision.paths.each do |change|
                    changeset.create_change(change)
                  end
                end
              end
            end
          end
          identifier_from = identifier_to + 1
        end
      end
    end
  rescue StandardError => e
    Rails.logger.error("Failed to fetch changesets from repository: #{e.message}")
  end

  private

  # Returns the relative url of the repository
  # Eg: root_url = file:///var/svn/foo
  #     url      = file:///var/svn/foo/bar
  #     => returns /bar
  def relative_url
    @relative_url ||= url.gsub(Regexp.new("^#{Regexp.escape(root_url || scm.root_url)}", Regexp::IGNORECASE), '')
  end
end
