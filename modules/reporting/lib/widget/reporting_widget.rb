

require_dependency 'reporting_helper'

class Widget::ReportingWidget < ActionView::Base
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::JavaScriptHelper
  include Rails.application.routes.url_helpers
  include ApplicationHelper
  include ReportingHelper
  include Redmine::I18n

  attr_accessor :output_buffer, :controller, :config, :_content_for, :_routes, :subject

  def self.new(subject)
    super(subject).tap do |o|
      o.subject = subject
    end
  end

  def current_language
    ::I18n.locale
  end

  def protect_against_forgery?
    false
  end

  def method_missing(name, *args, &block)
    controller.send(name, *args, &block)
  rescue NoMethodError
    raise NoMethodError, "undefined method `#{name}' for #<#{self.class}:0x#{object_id}>"
  end

  module RenderWidgetInstanceMethods
    def render_widget(widget, subject, options = {}, &block)
      i = widget.new(subject)
      i.config = config
      i._routes = _routes
      i._content_for = @_content_for
      i.controller = respond_to?(:controller) ? controller : self
      i.request = request
      i.render_with_options(options, &block)
    end
  end
end

ActionView::Base.include Widget::ReportingWidget::RenderWidgetInstanceMethods
ActionController::Base.include Widget::ReportingWidget::RenderWidgetInstanceMethods
