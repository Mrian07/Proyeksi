#-- encoding: UTF-8



module OpenProject
  module Info
    class << self
      def app_name; Setting.software_name end

      def url; Setting.software_url end

      def versioned_name; "#{app_name} #{OpenProject::VERSION.to_semver}" end

      # Creates the url string to a specific Redmine issue
      def issue(issue_id)
        url + 'issues/' + issue_id.to_s
      end
    end
  end
end
