
module RandomData
  class WikiSeeder
    def self.seed!(project)
      user = User.admin.first

      puts ''
      print_status ' ↳ Creating wikis'

      rand(5).times do
        print_status '.'
        wiki_page = WikiPage.create(
          wiki: project.wiki,
          title: Faker::Lorem.words(5).join(' ')
        )

        ## create some wiki contents
        rand(5).times do
          print_status '.'
          wiki_content = WikiContent.create(
            page: wiki_page,
            author: user,
            text: Faker::Lorem.paragraph(5, true, 3)
          )

          ## create some journal entries
          rand(5).times do
            wiki_content.reload
            wiki_content.text = Faker::Lorem.paragraph(5, true, 3) if rand(99).even?
            wiki_content.save!
          end
        end
      end
    end
  end
end
