#-- encoding: UTF-8

module Queries::Notifications
  [Queries::Notifications::Filters::ReadIanFilter,
   Queries::Notifications::Filters::IdFilter,
   Queries::Notifications::Filters::ProjectFilter,
   Queries::Notifications::Filters::ReasonFilter,
   Queries::Notifications::Filters::ResourceIdFilter,
   Queries::Notifications::Filters::ResourceTypeFilter].each do |filter|
    Queries::Register.filter Queries::Notifications::NotificationQuery,
                             filter
  end

  [Queries::Notifications::Orders::DefaultOrder,
   Queries::Notifications::Orders::ReasonOrder,
   Queries::Notifications::Orders::ProjectOrder,
   Queries::Notifications::Orders::ReadIanOrder].each do |order|
    Queries::Register.order Queries::Notifications::NotificationQuery,
                            order
  end

  [Queries::Notifications::GroupBys::GroupByReason,
   Queries::Notifications::GroupBys::GroupByProject].each do |group|
    Queries::Register.group_by Queries::Notifications::NotificationQuery,
                               group
  end
end
