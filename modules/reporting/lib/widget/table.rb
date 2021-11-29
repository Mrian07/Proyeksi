

class Widget::Table < Widget::Base
  extend Report::InheritedAttribute
  include ReportingHelper

  attr_accessor :debug, :fields, :mapping

  def initialize(query)
    raise ArgumentError, 'Tables only work on CostQuery!' unless query.is_a? CostQuery

    super
  end

  def resolve_table
    if @subject.group_bys.size == 0
      self.class.detailed_table
    elsif @subject.group_bys.size == 1
      self.class.simple_table
    else
      self.class.fancy_table
    end
  end

  def self.detailed_table(klass = nil)
    @@detail_table = klass if klass
    defined?(@@detail_table) ? @@detail_table : fancy_table
  end

  def self.simple_table(klass = nil)
    @@simple_table = klass if klass
    defined?(@@simple_table) ? @@simple_table : fancy_table
  end

  def self.fancy_table(klass = nil)
    @@fancy_table = klass if klass
    @@fancy_table
  end
  fancy_table Widget::Table::ReportTable

  def render
    write('<!-- table start -->')
    if @subject.result.count <= 0
      write(content_tag(:div, '', class: 'generic-table--no-results-container') do
        content_tag(:i, '', class: 'icon-info1') +
          content_tag(:span, I18n.t(:no_results_title_text), class: 'generic-table--no-results-title')
      end)
    else
      str = render_widget(resolve_table, @subject, @options.reverse_merge(to: @output))
      @cache_output.write(str.html_safe) if @cache_output
    end
  end
end
