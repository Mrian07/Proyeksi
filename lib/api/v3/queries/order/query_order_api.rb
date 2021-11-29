

module API
  module V3
    module Queries
      module Order
        class QueryOrderAPI < ::API::OpenProjectAPI
          resource :order do
            helpers do
              ##
              # Remove the order for the given work package
              def remove_order(wp_id)
                @query.ordered_work_packages.where(work_package_id: wp_id).delete_all
              end

              ##
              # Upsert with old rails ways, use +UPSERT+ once available.
              def upsert_order(wp_id, position)
                record = @query
                  .ordered_work_packages
                  .find_or_initialize_by(work_package_id: wp_id)

                if record.persisted?
                  record.update_column(:position, position)
                else
                  record.position = position
                  record.save
                end
              end
            end

            get do
              sql = <<~SQL.squish
                SELECT json_object_agg(work_package_id, position)
                FROM (
                  SELECT work_package_id, position FROM #{OrderedWorkPackage.table_name} WHERE query_id = :query_id
                ) sub;
              SQL

              sql_query = ::OpenProject::SqlSanitization
                .sanitize sql, query_id: @query.id

              ActiveRecord::Base.connection
                .exec_query(sql_query)
                .rows
                .first # first row
                .first || {}.to_json # first column (json object or null)
            end

            params do
              optional :delta, type: Hash
            end
            patch do
              params[:delta].each do |work_package_id, new_position|
                if new_position == -1
                  remove_order(work_package_id)
                else
                  upsert_order(work_package_id, new_position)
                end
              end

              @query.touch
              { t: ::API::V3::Utilities::DateTimeFormatter.format_datetime(@query.updated_at) }
            end
          end
        end
      end
    end
  end
end
