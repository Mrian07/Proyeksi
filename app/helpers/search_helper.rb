#-- encoding: UTF-8



module SearchHelper
  def highlight_tokens(text, tokens, text_on_not_found: false)
    split_text = text_split_by_token(text, tokens)

    return nil unless split_text.length > 1 || text_on_not_found

    result = ''
    split_text.each_with_index do |words, i|
      if result.length > 1200
        # maximum length of the preview reached
        result << '...'
        break
      end

      result << if i.even?
                  abbreviated_text(words)
                else
                  token_span(tokens, words)
                end
    end
    result.html_safe
  end

  def highlight_tokens_in_event(event, tokens)
    # This way, the attachments are only loaded in case the tokens are not found inside
    # the journal notes.
    highlight_tokens(last_journal(event).try(:notes), tokens) or
      highlight_tokens(attachment_fulltexts(event), tokens) or
      highlight_tokens(attachment_filenames(event), tokens) or
      highlight_tokens(event.event_description, tokens, text_on_not_found: true)
  end

  def text_split_by_token(text, tokens)
    return [text].compact unless text && tokens && !tokens.empty?

    re_tokens = tokens.map { |t| Regexp.escape(t) }
    regexp = Regexp.new "(#{re_tokens.join('|')})", Regexp::IGNORECASE
    text.split(regexp)
  end

  def has_tokens?(text, tokens)
    return false unless text && tokens && !tokens.empty?

    re_tokens = tokens.map { |t| Regexp.escape(t) }
    regexp = Regexp.new "(#{re_tokens.join('|')})", Regexp::IGNORECASE
    !!regexp.match(text)
  end

  def last_journal(event)
    if event.respond_to? :last_journal
      event.last_loaded_journal
    end
  end

  def notes_anchor(event)
    version = event.version.to_i

    version > 1 ? "note-#{version - 1}" : ''
  end

  def with_notes_anchor(event, tokens)
    if has_tokens? last_journal(event).try(:notes), tokens
      event.event_url.merge anchor: notes_anchor(last_journal(event))
    else
      event.event_url
    end
  end

  def type_label(t)
    ProyeksiApp::GlobalSearch.tab_name(t)
  end

  def current_scope
    params[:scope] ||
      ('subprojects' unless @project.nil? || @project.descendants.active.empty?) ||
      ('current_project' unless @project.nil?)
  end

  def link_to_previous_search_page(pagination_previous_date)
    link_to_content_update(I18n.t(:label_previous),
                           @search_params.merge(previous: 1,
                                                project_id: @project.try(:identifier),
                                                offset: pagination_previous_date.to_r.to_s),
                           class: 'navigate-left')
  end

  def link_to_next_search_page(pagination_next_date)
    link_to_content_update(I18n.t(:label_next),
                           @search_params.merge(previous: nil,
                                                project_id: @project.try(:identifier),
                                                offset: pagination_next_date.to_r.to_s),
                           class: 'navigate-right')
  end

  private

  def attachment_fulltexts(event)
    only_if_tsv_supported(event) do
      Attachment.where(id: event.attachment_ids).pluck(:fulltext).join(' ')
    end
  end

  def attachment_filenames(event)
    only_if_tsv_supported(event) do
      event.attachments&.map(&:filename)&.join(' ')
    end
  end

  def only_if_tsv_supported(event)
    if EnterpriseToken.allows_to?(:attachment_filters) && ProyeksiApp::Database.allows_tsv? && event.respond_to?(:attachments)
      yield
    end
  end

  def token_span(tokens, words)
    t = (tokens.index(words.downcase) || 0) % 4
    content_tag('span', h(words), class: "search-highlight token-#{t}")
  end

  def abbreviated_text(words)
    h(words.length > 100 ? "#{words.slice(0..44)} ... #{words.slice(-45..-1)}" : words)
  end
end
