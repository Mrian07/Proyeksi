#-- encoding: UTF-8



module API
  module V3
    module TimeEntries
      class FormRepresenter < ::API::Decorators::SimpleForm
        def model
          TimeEntry
        end
      end
    end
  end
end
