

require 'digest/sha1'

module ::Widget
  class Base < Widget::ReportingWidget
    attr_reader :engine, :output
    attr_accessor :request

    ##
    # Deactivate caching for certain widgets. If called on Widget::Base,
    # caching is deactivated globally
    def self.dont_cache!
      @dont_cache = true
    end

    ##
    # Query whether this widget class should be cached.
    def self.dont_cache?
      @dont_cache or self != Widget::Base && Widget::Base.dont_cache?
    end

    def initialize(query)
      @subject = query
      @engine = query.class
      @options = {}
    end

    ##
    # Write a string to the canvas. The string is marked as html_safe.
    # This will write twice, if @cache_output is set.
    def write(str)
      str ||= ''
      @output ||= ''.html_safe
      @output = @output + '' if @output.frozen? # Rails 2 freezes tag strings
      @output.concat str.html_safe
      @cache_output.concat(str.html_safe) if @cache_output
      str.html_safe
    end

    ##
    # Render this widget. Abstract method. Needs to call #write at least once
    def render
      raise NotImplementedError, "#render is missing in my subclass #{self.class}"
    end

    ##
    # Render this widget, passing options.
    # Available options:
    #   :to => canvas - The canvas (streaming or otherwise) to render to. Has to respond to #write
    def render_with_options(options = {}, &block)
      set_canvas(options.delete(:to)) if options.has_key? :to
      @options = options
      render_with_cache(options, &block)
      @output
    end

    def cache_key
      @cache_key ||= Digest::SHA1::hexdigest begin
        if subject.respond_to? :cache_key
          "#{I18n.locale}/#{self.class.name.demodulize}/#{subject.cache_key}/#{@options.sort_by(&:to_s)}"
        else
          subject.inspect
        end
      end
    end

    def cached?
      cache? && Rails.cache.exist?(cache_key)
    end

    private

    def cache?
      !self.class.dont_cache?
    end

    ##
    # Render this widget or serve it from cache
    def render_with_cache(_options = {}, &block)
      if cached?
        write Rails.cache.fetch(cache_key)
      else
        render(&block)
        Rails.cache.write(cache_key, @cache_output || @output) if cache?
      end
    end

    ##
    # Set the canvas. If the canvas object isn't a string (e.g. cannot be cached easily),
    # a @cache_output String is created, that will mirror what is being written to the canvas.
    def set_canvas(canvas)
      @cache_output = ''.html_safe
      @output = canvas
    end
  end
end
