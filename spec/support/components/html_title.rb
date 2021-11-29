

module Components
  class HtmlTitle
    include Capybara::DSL
    include RSpec::Matchers

    attr_reader :project

    def initialize(project = nil)
      @project = project
    end

    def expect_first_segment(title_part)
      expect(page).to have_title full_title(title_part)
    end

    def full_title(first_segment)
      if project
        "#{first_segment} | #{project.name} | #{Setting.app_title}"
      else
        "#{first_segment} | #{Setting.app_title}"
      end
    end
  end
end
