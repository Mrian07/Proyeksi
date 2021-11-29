#-- encoding: UTF-8



module Grids
  class Grid < ActiveRecord::Base
    self.table_name = :grids

    serialize :options, Hash

    has_many :widgets,
             class_name: 'Widget',
             dependent: :destroy,
             autosave: true

    def user_deletable?
      false
    end

    def to_s
      name.presence || self.class.to_s.demodulize
    end

    acts_as_attachable
  end
end
