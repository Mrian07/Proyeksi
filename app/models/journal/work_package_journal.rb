#-- encoding: UTF-8



class Journal::WorkPackageJournal < Journal::BaseJournal
  self.table_name = 'work_package_journals'

  belongs_to :project
  belongs_to :assigned_to, class_name: 'Principal'
  belongs_to :responsible, class_name: 'Principal'
end
