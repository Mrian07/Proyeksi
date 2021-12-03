#-- encoding: UTF-8

class WikiRedirect < ApplicationRecord
  belongs_to :wiki

  validates_presence_of :title, :redirects_to
  validates_length_of :title, :redirects_to, maximum: 255
end
