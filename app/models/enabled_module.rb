#-- encoding: UTF-8



class EnabledModule < ApplicationRecord
  belongs_to :project

  validates :name,
            presence: true,
            uniqueness: { scope: :project_id, case_sensitive: true }

  after_create :module_enabled

  private

  # after_create callback used to do things when a module is enabled
  def module_enabled
    case name
    when 'wiki'
      # Create a wiki with a default start page
      if project && project.wiki.nil?
        Wiki.create(project: project, start_page: 'Wiki')
      end
    when 'repository'
      if project &&
         project.repository.nil? &&
         Setting.repositories_automatic_managed_vendor.present?
        create_managed_repository
      end
    end
  end

  def create_managed_repository
    params = {
      scm_vendor: Setting.repositories_automatic_managed_vendor,
      scm_type: Repository.managed_type
    }

    service = SCM::RepositoryFactoryService.new(project,
                                                ActionController::Parameters.new(params))
    service.build_and_save
  end
end
