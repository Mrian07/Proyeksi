#-- encoding: UTF-8

class UserPreference < ApplicationRecord
  belongs_to :user
  delegate :notification_settings, to: :user
  serialize :settings, ::Serializers::IndifferentHashSerializer

  validates :user,
            presence: true
  ##
  # Retrieve keys from settings, and allow accessing
  # as boolean with ? suffix
  def method_missing(method_name, *args)
    key = method_name.to_s
    return super unless supported_settings_method?(key)

    action = key[-1]

    case action
    when '?'
      to_boolean send(key[..-2])
    when '='
      settings[key[..-2]] = args.first
    else
      settings[key]
    end
  end

  ##
  # We respond to all methods as we retrieve
  # the key from settings
  def respond_to_missing?(method_name, include_private = false)
    supported_settings_method?(method_name) || super
  end

  def [](attr_name)
    if attribute?(attr_name)
      super
    else
      send attr_name
    end
  end

  def []=(attr_name, value)
    if attribute?(attr_name)
      super
    else
      send :"#{attr_name}=", value
    end
  end

  def comments_sorting
    settings.fetch(:comments_sorting, ProyeksiApp::Configuration.default_comment_sort_order)
  end

  def comments_in_reverse_order?
    comments_sorting == 'desc'
  end

  def hide_mail
    settings.fetch(:hide_mail, true)
  end

  def auto_hide_popups=(value)
    settings[:auto_hide_popups] = to_boolean(value)
  end

  def auto_hide_popups?
    settings.fetch(:auto_hide_popups) { Setting.default_auto_hide_popups? }
  end

  def warn_on_leaving_unsaved?
    settings.fetch(:warn_on_leaving_unsaved, true)
  end

  def warn_on_leaving_unsaved=(value)
    settings[:warn_on_leaving_unsaved] = to_boolean(value)
  end

  # Provide an alias to form builders
  alias :comments_in_reverse_order :comments_in_reverse_order?
  alias :warn_on_leaving_unsaved :warn_on_leaving_unsaved?
  alias :auto_hide_popups :auto_hide_popups?

  def comments_in_reverse_order=(value)
    settings[:comments_sorting] = to_boolean(value) ? 'desc' : 'asc'
  end

  def time_zone
    super.presence || Setting.user_default_timezone.presence
  end

  def daily_reminders
    super.presence || { enabled: true, times: ["08:00:00+00:00"] }.with_indifferent_access
  end

  def immediate_reminders
    super.presence || { mentioned: false }.with_indifferent_access
  end

  def pause_reminders
    super.presence || { enabled: false }.with_indifferent_access
  end

  def workdays
    super.presence || [1, 2, 3, 4, 5]
  end

  def supported_settings_method?(method_name)
    UserPreferences::Schema.properties.include?(method_name.to_s.gsub(/\?|=\z/, ''))
  end

  private

  def to_boolean(value)
    ActiveRecord::Type::Boolean.new.cast(value)
  end

  def attribute?(name)
    %i[user user_id].include?(name.to_sym)
  end
end
