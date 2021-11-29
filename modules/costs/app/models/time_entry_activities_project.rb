#-- encoding: UTF-8



class TimeEntryActivitiesProject < ActiveRecord::Base
  belongs_to :project
  belongs_to :activity, class_name: 'TimeEntryActivity'
end
