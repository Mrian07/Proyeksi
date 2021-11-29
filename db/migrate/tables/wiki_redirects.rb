

require_relative 'base'

class Tables::WikiRedirects < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer 'wiki_id', null: false
      t.string 'title'
      t.string 'redirects_to'
      t.datetime 'created_on', null: false

      t.index %i[wiki_id title], name: 'wiki_redirects_wiki_id_title'
      t.index :wiki_id, name: 'index_wiki_redirects_on_wiki_id'
    end
  end
end
