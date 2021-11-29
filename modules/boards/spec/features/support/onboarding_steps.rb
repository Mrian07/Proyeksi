

module OnboardingSteps
  def step_through_onboarding_board_tour
    next_button.click
    expect(page).to have_text sanitize_string(I18n.t('js.onboarding.steps.boards.overview')), normalize_ws: true

    next_button.click
    expect(page)
      .to have_text sanitize_string(I18n.t('js.onboarding.steps.boards.lists')), normalize_ws: true

    next_button.click
    expect(page).to have_text sanitize_string(I18n.t('js.onboarding.steps.boards.add')), normalize_ws: true

    next_button.click
    expect(page)
      .to have_text sanitize_string(I18n.t('js.onboarding.steps.boards.drag')), normalize_ws: true
  end
end

RSpec.configure do |config|
  config.include OnboardingSteps
end
