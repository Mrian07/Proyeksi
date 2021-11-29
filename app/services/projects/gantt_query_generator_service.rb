#-- encoding: UTF-8



module Projects
  class GanttQueryGeneratorService
    DEFAULT_GANTT_QUERY ||=
      {
        c: %w[type id subject status],
        tll: '{"left":"startDate","right":"dueDate","farRight":null}',
        tzl: "auto",
        tv: true,
        hi: false,
        g: "project"
      }.to_json.freeze

    attr_reader :selected_project_ids

    class << self
      ##
      # Returns the current query or the default one if none was saved
      def current_query
        Setting.project_gantt_query.presence || default_gantt_query
      end

      def default_gantt_query
        default_with_filter = JSON
                              .parse(Projects::GanttQueryGeneratorService::DEFAULT_GANTT_QUERY)

        milestone_ids = Type.milestone.pluck(:id).map(&:to_s)
        if milestone_ids.any?
          default_with_filter.merge!('f' => [{ 'n' => 'type', 'o' => '=', 'v' => milestone_ids }])
        end

        JSON.dump(default_with_filter)
      end
    end

    def initialize(selected_project_ids)
      @selected_project_ids = selected_project_ids
    end

    def call
      # Read the raw query_props from the settings (filters and columns still serialized)
      params = params_from_settings.dup

      # Delete the parent filter
      params['f'] =
        if params['f']
          params['f'].reject { |filter| filter['n'] == 'project' }
        else
          []
        end

      # Ensure grouped by project
      params['g'] = 'project'
      params['hi'] = false

      # Ensure timeline visible
      params['tv'] = true

      # Add the parent filter
      params['f'] << { 'n' => 'project', 'o' => '=', 'v' => selected_project_ids }

      params.to_json
    end

    private

    def params_from_settings
      JSON.parse(self.class.current_query)
    rescue JSON::JSONError => e
      Rails.logger.error "Failed to read project gantt view, resetting to default. Error was: #{e.message}"
      Setting.project_gantt_query = self.class.default_gantt_query

      JSON.parse(self.class.default_gantt_query)
    end
  end
end
