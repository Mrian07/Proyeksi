#-- encoding: UTF-8

require 'rack/utils'

class WorkPackages::AutoCompletesController < ::ApplicationController
  def index
    @work_packages = work_package_with_id | work_packages_by_subject_or_id

    respond_to do |format|
      format.json { render request.format.to_sym => wp_hashes_with_string(@work_packages) }
    end
  end

  private

  def work_package_with_id
    query_term = params[:q].to_s

    if query_term =~ /\A\d+\z/
      work_package_scope.visible.where(id: query_term.to_i)
    else
      []
    end
  end

  def work_packages_by_subject_or_id
    query_term_sql = subject_or_id_query(params[:q].to_s)

    work_package_scope
      .visible
      .where(query_term_sql)
      .order("#{WorkPackage.table_name}.id ASC") # :id does not work because...
      .limit(10)
      .includes(:type)
  end

  def wp_hashes_with_string(work_packages)
    work_packages.map do |work_package|
      wp_hash = Hash.new
      work_package.attributes.each { |key, value| wp_hash[key] = Rack::Utils.escape_html(value) }
      wp_hash['to_s'] = Rack::Utils.escape_html(work_package.to_s)
      wp_hash
    end
  end

  def subject_or_id_query(query_term)
    if query_term =~ /\A\d+\z/
      ["#{WorkPackage.table_name}.subject LIKE :q OR
       CAST(#{WorkPackage.table_name}.id AS CHAR(13)) LIKE :q",
       { q: "%#{query_term}%" }]
    else
      ["LOWER(#{WorkPackage.table_name}.subject) LIKE :q",
       { q: "%#{query_term.downcase}%" }]
    end
  end

  def work_package_scope
    scope = WorkPackage.all

    # The filter on subject in combination with the ORDER BY on id
    # seems to trip MySql's usage of indexes on the order statement
    # I haven't seen similar problems on postgresql but there might be as the
    # data at hand was not very large.
    #
    # For MySql we are therefore helping the DB optimizer to use the correct index

    if ActiveRecord::Base.connection_config[:adapter] == 'mysql2'
      scope = scope.from("#{WorkPackage.table_name} USE INDEX(PRIMARY)")
    end

    scope
  end
end
