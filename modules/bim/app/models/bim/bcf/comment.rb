

module Bim::Bcf
  class Comment < ActiveRecord::Base
    self.table_name = :bcf_comments

    include InitializeWithUuid

    CREATE_ATTRIBUTES = %i[journal issue viewpoint reply_to].freeze
    UPDATE_ATTRIBUTES = %i[viewpoint reply_to].freeze

    belongs_to :journal
    belongs_to :issue, foreign_key: :issue_id, class_name: "Bim::Bcf::Issue"
    belongs_to :viewpoint, foreign_key: :viewpoint_id, class_name: "Bim::Bcf::Viewpoint", optional: true
    belongs_to :reply_to, foreign_key: :reply_to, class_name: "Bim::Bcf::Comment", optional: true

    validates_presence_of :uuid
    validates_uniqueness_of :uuid, scope: [:issue_id]

    def self.has_uuid?(uuid, issue_id)
      exists?(uuid: uuid, issue_id: issue_id)
    end
  end
end
