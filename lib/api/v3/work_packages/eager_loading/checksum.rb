#-- encoding: UTF-8

module API
  module V3
    module WorkPackages
      module EagerLoading
        class Checksum < Base
          def apply(work_package)
            work_package.cache_checksum = cache_checksum_of(work_package)
          end

          def self.module
            CacheChecksumAccessor
          end

          class << self
            def for(work_package)
              fetch_checksums_for(Array(work_package))[work_package.id]
            end

            def fetch_checksums_for(work_packages)
              WorkPackage
                .where(id: work_packages.map(&:id).uniq)
                .left_joins(*checksum_associations)
                .pluck('work_packages.id', Arel.sql(md5_concat.squish))
                .to_h
            end

            protected

            def md5_concat
              md5_parts = checksum_associations.map do |association_name|
                table_name = md5_checksum_table_name(association_name)

                %W[#{table_name}.id #{table_name}.updated_at]
              end.flatten

              <<-SQL
                MD5(CONCAT(#{md5_parts.join(', ')}))
              SQL
            end

            def checksum_associations
              %i[status author responsible assigned_to version priority category type]
            end

            def md5_checksum_table_name(association_name)
              case association_name
              when :responsible
                'responsibles_work_packages'
              when :assigned_to
                'assigned_tos_work_packages'
              else
                association_class(association_name).table_name
              end
            end

            def association_class(association_name)
              WorkPackage.reflect_on_association(association_name).class_name.constantize
            end
          end

          private

          def cache_checksum_of(work_package)
            cache_checksums[work_package.id]
          end

          def cache_checksums
            @cache_checksums ||= self.class.fetch_checksums_for(work_packages)
          end
        end

        module CacheChecksumAccessor
          extend ActiveSupport::Concern

          included do
            attr_accessor :cache_checksum
          end
        end
      end
    end
  end
end
