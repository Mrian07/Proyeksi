#-- encoding: UTF-8



module OpenProject
  module SyntaxHighlighting
    class << self
      # Highlights +text+ as the content of +filename+
      # Should not return line numbers nor outer pre tag
      # use CodeRay to scan normal text, since it's smart enough to find
      # the correct source encoding before passing it to ERB::Util.html_escape
      def highlight_by_filename(text, filename)
        language = guess_lexer(text, filename)

        highlight_by_language(text, language)
      end

      # Highlights +text+ using +language+ syntax
      def highlight_by_language(text, language, formatter = Rouge::Formatters::HTML.new)
        Rouge.highlight(text, language, formatter).html_safe
      end

      ##
      # Guesses the appropriate lexer for the given text using rouge's guesser
      # Can be used to extract information using the lexer's name, tag, desc methods
      def guess_lexer(text, filename = nil)
        guessers = [Rouge::Guessers::Source.new(text)]
        guessers << Rouge::Guessers::Filename.new(filename) if filename.present?

        begin
          Rouge::Lexer::guess guessers: guessers
        rescue StandardError => e
          if !e.message.nil? && e.message == 'Ambiguous guess: can\'t decide between ["html", "xml"]'
            Rouge::Lexers::HTML.new
          else
            raise e
          end
        end
      end
    end
  end
end
