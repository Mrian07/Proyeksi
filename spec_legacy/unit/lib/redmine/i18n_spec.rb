#-- encoding: UTF-8


require_relative '../../../legacy_spec_helper'

describe Redmine::I18n do
  include Redmine::I18n
  include ActionView::Helpers::NumberHelper

  it 'should date and time for each language' do
    Setting.date_format = ''
    valid_languages.each do |lang|
      set_language_if_valid lang
      expect do
        format_date(Date.today)
        format_time(Time.now)
        format_time(Time.now, false)
        refute_equal 'default', ::I18n.l(Date.today, format: :default), "date.formats.default missing in #{lang}"
        refute_equal 'time',    ::I18n.l(Time.now, format: :time),      "time.formats.time missing in #{lang}"
      end.not_to raise_error
      assert I18n.t('date.day_names').is_a?(Array)
      assert_equal 7, I18n.t('date.day_names').size

      assert I18n.t('date.month_names').is_a?(Array)
      assert_equal 13, I18n.t('date.month_names').size
    end
  end

  it 'should time format' do
    set_language_if_valid 'en'
    now = Time.parse('2011-02-20 15:45:22')
    Setting.time_format = '%H:%M'
    Setting.date_format = '%Y-%m-%d'
    assert_equal '2011-02-20 15:45', format_time(now)
    assert_equal '15:45', format_time(now, false)

    Setting.date_format = ''
    assert_equal '02/20/2011 15:45', format_time(now)
    assert_equal '15:45', format_time(now, false)
  end

  it 'should time format default' do
    set_language_if_valid 'en'
    now = Time.parse('2011-02-20 15:45:22')
    Setting.time_format = ''
    Setting.date_format = '%Y-%m-%d'
    assert_equal '2011-02-20 03:45 PM', format_time(now)
    assert_equal '03:45 PM', format_time(now, false)

    Setting.date_format = ''
    assert_equal '02/20/2011 03:45 PM', format_time(now)
    assert_equal '03:45 PM', format_time(now, false)
  end

  it 'should time format' do
    set_language_if_valid 'en'
    now = Time.now
    Setting.time_format = '%H %M'
    Setting.date_format = '%d %m %Y'
    assert_equal now.strftime('%d %m %Y %H %M'), format_time(now)
    assert_equal now.strftime('%H %M'), format_time(now, false)
  end

  it 'should utc time format' do
    set_language_if_valid 'en'
    now = Time.now
    Setting.time_format = '%H %M'
    Setting.date_format = '%d %m %Y'
    assert_equal now.localtime.strftime('%d %m %Y %H %M'), format_time(now.utc)
    assert_equal now.localtime.strftime('%H %M'), format_time(now.utc, false)
  end

  it 'should number to human size for each language' do
    valid_languages.each do |lang|
      set_language_if_valid lang
      expect do
        number_to_human_size(1024 * 1024 * 4)
      end.not_to raise_error
    end
  end

  it 'should fallback' do
    ::I18n.backend.store_translations(:en, untranslated: 'Untranslated string')
    ::I18n.locale = 'en'
    assert_equal 'Untranslated string', I18n.t(:untranslated)
    ::I18n.locale = 'de'
    assert_equal 'Untranslated string', I18n.t(:untranslated)

    ::I18n.backend.store_translations(:de, untranslated: 'Keine Übersetzung')
    ::I18n.locale = 'en'
    assert_equal 'Untranslated string', I18n.t(:untranslated)
    ::I18n.locale = 'de'
    assert_equal 'Keine Übersetzung', I18n.t(:untranslated)
  end
end
