

module API
  module V3
    module Queries
      module SortBys
        class QuerySortBysAPI < ::API::ProyeksiAppAPI
          resource :sort_bys do
            helpers do
              def convert_to_ar(attribute)
                ::API::Utilities::WpPropertyNameConverter.to_ar_name(attribute)
              end

              def find_column(attribute)
                ar_id = convert_to_ar(attribute).to_sym

                Query
                  .sortable_columns
                  .detect { |candidate| candidate.name == ar_id }
              end
            end

            params do
              requires :id, desc: 'Group by id'
              requires :direction, desc: 'Direction of sorting'
            end

            after_validation do
              authorize(:view_work_packages, global: true, user: current_user)
            end

            namespace ':id-:direction' do
              get do
                column = find_column(params[:id])

                begin
                  decorator = ::API::V3::Queries::SortBys::SortByDecorator.new(column,
                                                                               params[:direction])
                  ::API::V3::Queries::SortBys::QuerySortByRepresenter.new(decorator)
                rescue ArgumentError
                  raise API::Errors::NotFound
                end
              end
            end
          end
        end
      end
    end
  end
end
