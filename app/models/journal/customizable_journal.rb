#-- encoding: UTF-8



class Journal::CustomizableJournal < Journal::AssociatedJournal
  self.table_name = 'customizable_journals'

  belongs_to :custom_field
end
