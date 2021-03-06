module RandomData
  class NewsSeeder
    def self.seed!(project)
      user = User.admin.first

      puts ''
      print_status ' ↳ Creating news'

      rand(30).times do
        print_status '.'
        news = News.create project: project,
                           author: user,
                           title: Faker::Lorem.characters(60),
                           summary: Faker::Lorem.paragraph(1, true, 3),
                           description: Faker::Lorem.paragraph(5, true, 3)

        ## create some journal entries
        rand(5).times do
          news.reload

          news.title = Faker::Lorem.words(5).join(' ').slice(0, 60) if rand(99).even?
          news.summary = Faker::Lorem.paragraph(1, true, 3) if rand(99).even?
          news.description = Faker::Lorem.paragraph(5, true, 3) if rand(99).even?

          news.save!
        end
      end
    end
  end
end
