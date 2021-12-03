module DemoData
  class VersionBuilder
    include ::DemoData::References

    attr_reader :config, :project

    def initialize(config, project)
      @config = config
      @project = project
    end

    def create!
      create_version if valid?
    end

    private

    def valid?
      true
    end

    def create_version
      version.tap do |version|
        project.versions << version
      end
    end

    def version
      version = Version.create!(
        name: config[:name],
        status: config[:status],
        sharing: config[:sharing],
        project: project
      )

      set_wiki! version, config[:wiki] if config[:wiki]

      version
    end

    def set_wiki!(version, config)
      version.wiki_page_title = config[:title]
      page = WikiPage.create! wiki: version.project.wiki, title: version.wiki_page_title

      content = with_references config[:content], project
      Journal::NotificationConfiguration.with false do
        WikiContent.create! page: page, author: User.admin.first, text: content
      end

      version.save!
    end
  end
end
