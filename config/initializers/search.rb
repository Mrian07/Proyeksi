#-- encoding: UTF-8



Redmine::Search.map do |search|
  search.register :work_packages
  search.register :news
  search.register :changesets
  search.register :wiki_pages
  search.register :messages
  search.register :projects
end
