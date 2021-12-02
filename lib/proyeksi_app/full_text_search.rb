#-- encoding: UTF-8



module ProyeksiApp
  # This module provides utility methods to work with PostgreSQL's full-text capabilities (TSVECTOR)
  module FullTextSearch
    DISALLOWED_CHARACTERS = /['?\\:()&|!*<>]/

    def self.tsv_where(table_name, column_name, value, concatenation: :and, normalization: :text)
      if ProyeksiApp::Database.allows_tsv?
        column = "\"#{table_name.to_s}\".\"#{column_name.to_s}_tsv\""
        query = tokenize(value, concatenation, normalization)
        language = ProyeksiApp::Configuration.main_content_language

        ActiveRecord::Base.send(
          :sanitize_sql_array, ["#{column} @@ to_tsquery(?, ?)",
                                language,
                                query]
        )
      end
    end

    def self.tokenize(text, concatenation = :and, normalization = :text)
      terms = normalize(clean_terms(text), normalization).split(/\s+/).reject(&:blank?)

      case concatenation
      when :and
        # all terms need to hit
        terms.join ' & '
      when :and_not
        # all terms must not hit.
        "! #{terms.join(' & ! ')}"
      end
    end

    def self.normalize(text, type = :text)
      case type
      when :text
        normalize_text(text)
      when :filename
        normalize_filename(text)
      end
    end

    def self.normalize_text(text)
      I18n.with_locale(:en) { I18n.transliterate(text.to_s.downcase) }
    end

    def self.normalize_filename(filename)
      name_in_words = to_words filename.to_s.downcase
      I18n.with_locale(:en) { I18n.transliterate(name_in_words) }
    end

    def self.to_words(text)
      text.gsub /[^[:alnum:]]/, ' '
    end

    def self.clean_terms(terms)
      terms.gsub(DISALLOWED_CHARACTERS, ' ')
    end
  end
end
