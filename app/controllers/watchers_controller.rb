#-- encoding: UTF-8



class WatchersController < ApplicationController
  before_action :find_watched_by_object
  before_action :find_project
  before_action :require_login, :check_project_privacy, only: %i[watch unwatch]

  def watch
    if @watched.respond_to?(:visible?) && !@watched.visible?(User.current)
      render_403
    else
      set_watcher(User.current, true)
    end
  end

  def unwatch
    set_watcher(User.current, false)
  end

  private

  def find_watched_by_object
    klass = params[:object_type].singularize.camelcase.constantize

    return false unless klass.respond_to?('watched_by') and
                        klass.ancestors.include? Redmine::Acts::Watchable and
                        params[:object_id].to_s =~ /\A\d+\z/

    unless @watched = klass.find(params[:object_id])
      render_404
    end
  end

  def find_project
    @project = @watched.project
  end

  def set_watcher(user, watching)
    @watched.set_watcher(user, watching)
    redirect_back(fallback_location: home_url)
  end
end
