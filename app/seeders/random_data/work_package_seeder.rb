
module RandomData
  class WorkPackageSeeder
    attr_accessor :project, :user, :statuses, :repository, :types

    def initialize(project)
      self.project = project
      self.user = User.admin.first
      self.statuses = Status.all
      self.repository = Repository.first
      self.types = project.types.all.reject(&:is_milestone?)
    end

    def seed!(random: true)
      puts ''
      print_status ' ↳ Creating work_packages'

      seed_random_work_packages
    end

    private

    def seed_random_work_packages
      rand(50).times do
        print_status '.'
        work_package = WorkPackage.create!(
          project: project,
          author: user,
          subject: Faker::Lorem.words(8).join(' '),
          status: statuses.sample,
          type: types.sample,
          start_date: s = Date.today - rand(-24..25).days,
          due_date: s + rand(1..120).days
        )
        work_package.priority = IssuePriority.all.sample
        work_package.description = Faker::Lorem.paragraph(5, true, 3)
        work_package.save!
      end

      work_package = WorkPackage.first

      if repository
        add_changeset(work_package)
      end

      add_time_entries(work_package)
      add_attachments(work_package)
      add_custom_values(work_package)
      make_changes(work_package)
    end

    def add_changeset(work_package)
      2.times do |changeset_count|
        print_status '.'
        changeset = Changeset.create(
          repository: repository,
          user: user,
          revision: work_package.id * 10 + changeset_count,
          scmid: work_package.id * 10 + changeset_count,
          work_packages: [work_package],
          committer: Faker::Name.name,
          committed_on: Date.today,
          comments: Faker::Lorem.words(8).join(' ')
        )

        5.times do
          print_status '.'
          change = Change.create(
            action: Faker::Lorem.characters(1),
            path: Faker::Internet.url
          )

          changeset.file_changes << change
        end

        repository.changesets << changeset

        changeset.save!

        rand(5).times do
          print_status '.'
          changeset.reload

          changeset.committer = Faker::Name.name if rand(99).even?
          changeset.committed_on = Date.today + rand(999) if rand(99).even?
          changeset.comments = Faker::Lorem.words(8).join(' ') if rand(99).even?

          changeset.save!
        end
      end
    end

    def add_time_entries(work_package)
      5.times do |time_entry_count|
        time_entry = TimeEntry.create(
          project: project,
          user: user,
          work_package: work_package,
          spent_on: Date.today + time_entry_count,
          activity: time_entry_activities.sample,
          hours: time_entry_count
        )
        work_package.time_entries << time_entry
      end
    end

    def add_attachments(work_package)
      3.times do |_attachment_count|
        file = OpenProject::Files.create_uploaded_file(name: Faker::Lorem.words(8).join(' '))
        attachment = Attachment.new(
          container: work_package,
          author: user,
          file: file
        )
        attachment.save!

        work_package.attachments << attachment
      end
    end

    def add_custom_values(work_package)
      project.work_package_custom_fields.each do |custom_field|
        work_package.type.custom_fields << custom_field if !work_package.type.custom_fields.include?(custom_field)
        work_package.custom_values << CustomValue.new(custom_field: custom_field,
                                                      value: Faker::Lorem.words(8).join(' '))
      end

      work_package.type.save!
      work_package.save!
    end

    def make_changes(work_package)
      20.times do
        print_status '.'
        work_package.reload

        work_package.status = statuses.sample if rand(99).even?
        work_package.subject = Faker::Lorem.words(8).join(' ') if rand(99).even?
        work_package.description = Faker::Lorem.paragraph(5, true, 3) if rand(99).even?
        work_package.type = types.sample if rand(99).even?

        work_package.time_entries.each do |t|
          t.spent_on = Date.today + rand(100) if rand(99).even?
          t.activity = time_entry_activities.sample if rand(99).even?
          t.hours = rand(10) if rand(99).even?
        end

        work_package.reload

        attachments = work_package.attachments.select { |_a| rand(999) < 10 }
        work_package.attachments = work_package.attachments - attachments

        work_package.reload

        work_package.custom_values.each do |cv|
          cv.value = Faker::Code.isbn if rand(99).even?
        end

        work_package.save!
      end
    end
  end
end
