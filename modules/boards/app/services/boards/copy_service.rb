#-- encoding: UTF-8



module Boards
  class CopyService < ::Grids::CopyService
    protected

    def initialize_new_grid!(new_board, original_board, _params)
      new_board.project = state.project || original_board.project
    end
  end
end
