#-- encoding: UTF-8



class JournalsController < ApplicationController
  before_action :find_journal, except: [:index]
  before_action :find_optional_project, only: [:index]
  before_action :authorize, only: [:diff]
  accept_key_auth :index
  menu_item :issues

  include QueriesHelper
  include SortHelper

  def index
    retrieve_query
    sort_init 'id', 'desc'
    sort_update(@query.sortable_key_by_column_name)

    if @query.valid?
      @journals = @query.work_package_journals(order: "#{Journal.table_name}.created_at DESC",
                                               limit: 25)
    end

    respond_to do |format|
      format.atom do
        render layout: false,
               content_type: 'application/atom+xml',
               locals: { title: journals_index_title,
                         journals: @journals }
      end
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def diff
    field = params[:field].parameterize.underscore.to_sym

    unless valid_diff?
      return render_404
    end

    unless @journal.details[field].is_a?(Array)
      return render_400 message: I18n.t(:error_journal_attribute_not_present, attribute: field)
    end

    from = @journal.details[field][0]
    to = @journal.details[field][1]

    @diff = Redmine::Helpers::Diff.new(to, from)
    @journable = @journal.journable
    respond_to do |format|
      format.html
      format.js do
        render partial: 'diff', locals: { diff: @diff }
      end
    end
  end

  private

  def find_journal
    @journal = Journal.find(params[:id])
    @project = @journal.journable.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  # Is this a valid field for diff'ing?
  def valid_field?(field)
    field.to_s.strip == 'description'
  end

  def valid_diff?
    valid_field?(params[:field]) &&
      @journal.journable.instance_of?(WorkPackage)
  end

  def journals_index_title
    (@project ? @project.name : Setting.app_title) + ': ' + (@query.new_record? ? I18n.t(:label_changes_details) : @query.name)
  end
end
