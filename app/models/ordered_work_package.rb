#-- encoding: UTF-8


#
class OrderedWorkPackage < ApplicationRecord
  belongs_to :query
  belongs_to :work_package

  default_scope { order("position NULLS LAST") }
end
