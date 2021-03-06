#-- encoding: UTF-8

module WatchersHelper
  # Create a link to watch/unwatch object
  #
  # * :replace - a string or array of strings with css selectors that will be updated, whenever the watcher status is changed
  def watcher_link(object, user, options = { replace: '.watcher_link', class: 'watcher_link' })
    options = options.with_indifferent_access
    raise ArgumentError, 'Missing :replace option in options hash' if options['replace'].blank?

    return '' unless user&.logged? && object.respond_to?('watched_by?')

    watched = object.watched_by?(user)

    html_options = options
    path = send(:"#{(watched ? 'unwatch' : 'watch')}_path", object_type: object.class.to_s.underscore.pluralize,
                object_id: object.id,
                replace: options.delete('replace'))
    html_options[:class] = html_options[:class].to_s + ' button'

    method = watched ? :delete : :post

    label = watched ? I18n.t(:button_unwatch) : I18n.t(:button_watch)

    link_to(content_tag(:i, '', class: watched ? 'button--icon icon-watched' : ' button--icon icon-unwatched') + ' ' +
              content_tag(:span, label, class: 'button--text'), path, html_options.merge(method: method))
  end
end
