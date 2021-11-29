#-- encoding: UTF-8


module BasicData
  class PrioritySeeder < Seeder
    def seed_data!
      IssuePriority.transaction do
        data.each do |attributes|
          IssuePriority.create!(attributes)
        end
      end
    end

    def applicable?
      IssuePriority.all.empty?
    end

    def not_applicable_message
      'Skipping priorities as there are already some configured'
    end

    def data
      raise NotImplementedError
    end
  end
end
