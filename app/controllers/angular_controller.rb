#-- encoding: UTF-8



class AngularController < ApplicationController
  before_action :require_login

  def empty_layout
    # Frontend will handle rendering
    # but we will need to render with layout
    render html: '', layout: 'angular/angular'
  end

  def notifications_layout
    # Frontend will handle rendering
    # but we will need to render with notification specific layout
    render html: '', layout: 'angular/notifications'
  end
end
