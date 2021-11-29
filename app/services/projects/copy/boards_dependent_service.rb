#-- encoding: UTF-8



module Projects::Copy
  class BoardsDependentService < Dependency
    def self.human_name
      I18n.t(:'boards.label_boards')
    end

    def source_count
      ::Boards::Grid.where(project: source).count
    end

    protected

    # Copies boards from +project+
    # Only includes the queries visible in the wp table view.
    def copy_dependency(params)
      ::Boards::Grid.where(project: source).find_each do |board|
        duplicate_board(board, params)
      end
    end

    def duplicate_board(board, params)
      ::Boards::CopyService
        .new(source: board, user: user)
        .with_state(state)
        .call(params.merge)
        .tap { |call| result.merge!(call, without_success: true) }
    end
  end
end
