# AssociatedJournals that belong to another journal reflecting
# an has_many relation (e.g. custom_values) on the journaled object.
class Journal::AssociatedJournal < ApplicationRecord
  self.abstract_class = true

  belongs_to :author, class_name: 'User'
  belongs_to :journal
end
