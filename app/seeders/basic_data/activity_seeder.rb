#-- encoding: UTF-8


module BasicData
  class ActivitySeeder < Seeder
    def seed_data!
      TimeEntryActivity.transaction do
        data.each do |attributes|
          TimeEntryActivity.create(attributes)
        end
      end
    end

    def applicable?
      TimeEntryActivity.all.empty?
    end

    def not_applicable_message
      'Skipping activities as there are already some configured'
    end

    def data
      raise NotImplementedError
    end
  end
end
