#-- encoding: UTF-8



class HomescreenController < ApplicationController
  skip_before_action :check_if_login_required, only: [:robots]

  layout 'no_menu'

  def index
    @newest_projects = Project.visible.newest.take(3)
    @newest_users = User.active.newest.take(3)
    @news = News.latest(count: 3)
    @announcement = Announcement.active_and_current

    @homescreen = OpenProject::Static::Homescreen
  end

  def robots
    @projects = Project.active.public_projects
  end
end
