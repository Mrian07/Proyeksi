

module Pages::Meetings
  class Base < Pages::Page
    attr_accessor :project

    def initialize(project)
      self.project = project
    end

    def toast_type
      :rails
    end
  end
end
