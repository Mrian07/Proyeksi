

module Constants
  class ARToAPIConversions
    # Conversions that are bidirectional:
    # * from the API to AR
    # * from AR to the API
    WELL_KNOWN_CONVERSIONS = {
      assigned_to: 'assignee',
      version: 'version',
      done_ratio: 'percentageDone',
      estimated_hours: 'estimatedTime',
      remaining_hours: 'remainingTime',
      spent_hours: 'spentTime',
      subproject: 'subprojectId',
      relation_type: 'type',
      mail: 'email',
      column_names: 'columns',
      is_public: 'public',
      sort_criteria: 'sortBy',
      message: 'post',
      firstname: 'firstName',
      lastname: 'lastName',
      member: 'membership'
    }.freeze

    # Conversions that are unidirectional (from the API to AR)
    # This can be used to still support renamed filters/sort_by, like for created/updatedOn.
    WELL_KNOWN_API_TO_AR_CONVERSIONS = {
      created_on: 'created_at',
      updated_on: 'updated_at'
    }.freeze

    class << self
      def add(map)
        conversions.push(map)
      end

      def all
        conversions.inject(:merge)
      end

      def api_to_ar_conversions
        @api_to_ar_conversions ||= Constants::ARToAPIConversions.all.inject({}) do |result, (k, v)|
          result[v.underscore] = k.to_s
          result
        end.merge(WELL_KNOWN_API_TO_AR_CONVERSIONS.stringify_keys)
      end

      private

      def conversions
        @conversions ||= [WELL_KNOWN_CONVERSIONS]
      end
    end
  end
end
