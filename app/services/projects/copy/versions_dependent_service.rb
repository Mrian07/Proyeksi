#-- encoding: UTF-8



module Projects::Copy
  class VersionsDependentService < Dependency
    def self.human_name
      I18n.t(:label_version_plural)
    end

    def source_count
      source.versions.count
    end

    protected

    def copy_dependency(params:)
      version_id_map = {}
      source.versions.each do |source_version|
        version = target.versions.create source_version.attributes.dup.except('id', 'project_id', 'created_at', 'updated_at')
        version_id_map[source_version.id] = version.id
      end

      state.version_id_lookup = version_id_map
    end
  end
end
