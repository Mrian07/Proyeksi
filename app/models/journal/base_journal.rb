

class Journal::BaseJournal < ApplicationRecord
  self.abstract_class = true

  has_one :journal, as: :data, inverse_of: :data, dependent: :destroy
  belongs_to :author, class_name: 'User'

  def journaled_attributes
    attributes.symbolize_keys.select { |k, _| self.class.journaled_attributes.include? k }
  end

  def self.journaled_attributes
    @journaled_attributes ||= column_names.map(&:to_sym) - excluded_attributes
  end

  def self.excluded_attributes
    [primary_key.to_sym, inheritance_column.to_sym]
  end
  private_class_method :excluded_attributes
end
