#-- encoding: UTF-8

module AvatarHelper
  # Returns the avatar image tag for the given +user+ if avatars are enabled
  # +user+ can be a User or a string that will be scanned for an email address (eg. 'joe <joe@foo.bar>')
  def avatar(_user, _options = {})
    ''.html_safe
  end

  # Returns the avatar image url for the given +user+ if avatars are enabled
  def avatar_url(_user, _options = {})
    ''.html_safe
  end
end
