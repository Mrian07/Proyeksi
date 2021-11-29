#-- encoding: UTF-8



require_dependency 'grids/grid'

module Boards
  class Grid < ::Grids::Grid
    belongs_to :project
    validates_presence_of :name

    before_destroy :delete_queries

    set_acts_as_attachable_options view_permission: :show_board_views,
                                   delete_permission: :manage_board_views,
                                   add_permission: :manage_board_views

    def user_deletable?
      true
    end

    def contained_queries
      ::Query.where(id: contained_query_ids)
    end

    def to_s
      "#{I18n.t('boards.label_board')} '#{name}'"
    end

    private

    def delete_queries
      contained_queries.delete_all
    end

    def contained_query_ids
      widgets
        .map { |w| w.options['queryId'] || w.options['query_id'] }
        .compact
    end
  end
end
