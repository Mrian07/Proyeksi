module DemoData
  class WikiSeeder < Seeder
    attr_reader :project, :key

    def initialize(project, key)
      @project = project
      @key = key
    end

    def seed_data!
      text = project_data_for(key, 'wiki')

      return if text.is_a?(String) && text.start_with?("translation missing")

      user = User.admin.first

      if text.is_a? String
        text = [{ title: "Wiki", content: text }]
      end

      print_status '    ↳ Creating wikis'

      Array(text).each do |data|
        create_wiki_page!(
          data,
          project: project,
          user: user
        )
      end

      puts
    end

    def create_wiki_page!(data, project:, user:, parent: nil)
      wiki_page = WikiPage.create!(
        wiki: project.wiki,
        title: data[:title],
        parent: parent
      )

      print_status '.'
      WikiContent.create!(
        page: wiki_page,
        author: user,
        text: data[:content]
      )

      if data[:children]
        Array(data[:children]).each do |child_data|
          create_wiki_page!(
            child_data,
            project: project,
            user: user,
            parent: wiki_page
          )
        end
      end
    end
  end
end
