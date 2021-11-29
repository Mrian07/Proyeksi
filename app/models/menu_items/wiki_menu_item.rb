#-- encoding: UTF-8



class MenuItems::WikiMenuItem < MenuItem
  belongs_to :wiki, foreign_key: 'navigatable_id'

  scope :main_items, ->(wiki_id) {
    where(navigatable_id: wiki_id, parent_id: nil)
      .includes(:children)
      .order(Arel.sql('title ASC'))
  }

  def slug
    WikiPage.slug(name)
  end

  def item_class
    slug
  end

  def menu_identifier
    "wiki-#{slug}".to_sym
  end

  def index_page
    !!options[:index_page]
  end

  def index_page=(value)
    options[:index_page] = value
  end

  def new_wiki_page
    !!options[:new_wiki_page]
  end

  def new_wiki_page=(value)
    options[:new_wiki_page] = value
  end

  def as_entry_item_symbol
    self.class.add_entry_item_prefix(menu_identifier)
  end

  def self.add_entry_item_prefix(identifier)
    "entry-item-#{identifier}".to_sym
  end
end
