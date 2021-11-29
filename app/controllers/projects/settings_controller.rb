#-- encoding: UTF-8



class Projects::SettingsController < ApplicationController
  before_action :find_project_by_project_id
  before_action :authorize

  def show; end
end
