#-- encoding: UTF-8



class HelpController < ApplicationController
  def keyboard_shortcuts
    redirect_to OpenProject::Static::Links[:shortcuts][:href]
  end

  def text_formatting
    default_link = OpenProject::Static::Links[:text_formatting][:href]
    help_link = OpenProject::Configuration.force_formatting_help_link.presence || default_link

    redirect_to help_link
  end
end
