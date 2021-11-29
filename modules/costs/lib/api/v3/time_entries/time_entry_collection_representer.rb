#-- encoding: UTF-8



module API
  module V3
    module TimeEntries
      class TimeEntryCollectionRepresenter < ::API::Decorators::OffsetPaginatedCollection
        link :createTimeEntry do
          next unless current_user.allowed_to_globally?(:log_time)

          {
            href: api_v3_paths.create_time_entry_form,
            method: :post
          }
        end

        link :createTimeEntryImmediately do
          next unless current_user.allowed_to_globally?(:log_time)

          {
            href: api_v3_paths.time_entries,
            method: :post
          }
        end
      end
    end
  end
end
