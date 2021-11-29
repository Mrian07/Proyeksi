

require 'spec_helper'

module OnboardingHelper
  def step_through_onboarding_wp_tour(project, wp)
    expect(page).not_to have_selector('.loading-indicator')
    expect(page).to have_text sanitize_string(I18n.t('js.onboarding.steps.wp.list')), normalize_ws: true

    next_button.click
    expect(page).to have_current_path project_work_package_path(project, wp.id, 'activity')
    expect(page).to have_text sanitize_string(I18n.t('js.onboarding.steps.wp.full_view')), normalize_ws: true

    next_button.click
    expect(page).to have_text sanitize_string(I18n.t('js.onboarding.steps.wp.back_button')), normalize_ws: true

    next_button.click
    expect(page).to have_text sanitize_string(I18n.t('js.onboarding.steps.wp.create_button')), normalize_ws: true

    next_button.click
    expect(page).to have_text sanitize_string(I18n.t('js.onboarding.steps.wp.timeline_button')), normalize_ws: true

    next_button.click
    expect(page).to have_text sanitize_string(I18n.t('js.onboarding.steps.wp.timeline')), normalize_ws: true

    next_button.click
    expect(page).to have_text sanitize_string(I18n.t('js.onboarding.steps.sidebar_arrow')), normalize_ws: true
  end

  def step_through_onboarding_main_menu_tour(has_full_capabilities:)
    if has_full_capabilities
      next_button.click
      expect(page).to have_text sanitize_string(I18n.t('js.onboarding.steps.members')), normalize_ws: true

      next_button.click
      expect(page).to have_text sanitize_string(I18n.t('js.onboarding.steps.wiki')), normalize_ws: true

      next_button.click
      expect(page).to have_text sanitize_string(I18n.t('js.onboarding.steps.quick_add_button')), normalize_ws: true
    end

    next_button.click
    expect(page).to have_text sanitize_string(I18n.t('js.onboarding.steps.help_menu')), normalize_ws: true

    next_button.click
    expect(page).not_to have_selector '.enjoy_hint_label'
  end

  def sanitize_string(string)
    Sanitize.clean(string).squish
  end
end

RSpec.configure do |config|
  config.include OnboardingHelper
end
