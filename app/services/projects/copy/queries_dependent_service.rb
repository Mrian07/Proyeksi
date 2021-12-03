#-- encoding: UTF-8

module Projects::Copy
  class QueriesDependentService < Dependency
    def self.human_name
      I18n.t(:label_query_plural)
    end

    def source_count
      source.queries.count
    end

    protected

    # Copies queries from +project+
    # Only includes the queries visible in the wp table view.
    def copy_dependency(params:)
      mapping = queries_to_copy.map do |query|
        copy = duplicate_query(query, params)
        # Either assign the successfully copied query's ID or nil to indicate
        # it could not be copied.
        new_id = copy.map(&:id).to_a.first

        [query.id, new_id]
      end

      state.query_id_lookup = Hash[mapping]
    end

    def queries_to_copy
      source.queries.non_hidden.includes(:query_menu_item)
    end

    def duplicate_query(query, params)
      ::Queries::CopyService
        .new(source: query, user: user)
        .with_state(state)
        .call(params.merge)
        .on_failure { |result| add_error! query, result.errors }
    end
  end
end
