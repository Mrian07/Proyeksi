#-- encoding: UTF-8

class WorkPackages::CalendarsController < ApplicationController
  menu_item :calendar
  before_action :find_optional_project

  def index
    render layout: 'angular/angular'
  end
end
