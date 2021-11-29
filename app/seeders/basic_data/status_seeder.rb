#-- encoding: UTF-8


module BasicData
  class StatusSeeder < Seeder
    def seed_data!
      Status.transaction do
        data.each do |attributes|
          Status.create!(attributes)
        end
      end
    end

    def applicable
      Status.all.any?
    end

    def not_applicable_message
      'Skipping statuses - already exists/configured'
    end

    def data
      raise NotImplementedError
    end
  end
end
