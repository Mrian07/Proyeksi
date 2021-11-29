

# This module includes some boilerplate code for pagination using scopes.
# #search_scope may be overridden by the model to change (restrict) the search scope
# and MUST return a scope or its corresponding hash.

module Pagination::Model
  def self.included(base)
    base.extend self
  end

  def self.extended(base)
    unless base.respond_to? :like
      base.scope :like, ->(q) {
        s = "%#{q.to_s.strip.downcase}%"
        base.where(['LOWER(name) LIKE :s', { s: s }])
          .order(Arel.sql('name'))
      }
    end

    base.instance_eval do
      def paginate_scope!(scope, options = {})
        limit = options.fetch(:page_limit) || 10
        page = options.fetch(:page) || 1

        scope.paginate(per_page: limit, page: page)
      end

      # ignores options passed in from the controller, overwrite to use 'em
      def search_scope(query, _options = {})
        like(query)
      end
    end
  end
end
