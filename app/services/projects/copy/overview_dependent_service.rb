#-- encoding: UTF-8



module Projects::Copy
  class OverviewDependentService < Dependency
    def self.human_name
      I18n.t(:'overviews.label')
    end

    protected

    # Copies the overview from +project+
    def copy_dependency(params)
      ::Grids::Overview.where(project: source).find_each do |overview|
        duplicate_overview(overview, params)
      end
    end

    def duplicate_overview(overview, params)
      ::Overviews::CopyService
        .new(source: overview, user: user)
        .with_state(state)
        .call(params.merge)
        .tap { |call| result.merge!(call, without_success: true) }
    end
  end
end
