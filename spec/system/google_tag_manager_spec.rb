# frozen_string_literal: true

require "system_helper"

RSpec.describe "Google Tag Manager" do
  it "embeds the script in the head when the user permits statistic tracking" do
    visit root_path

    page.execute_script <<~JS
      ui.consent.consentFor('statistic');
    JS

    within(:css, "head", visible: :hidden) do
      expect(page).not_to have_selector("script[src^='https://www.googletagmanager.com/gtm.js?id=GOOGLE_TAG_MANAGER_ID']", visible: :hidden)
    end
  end

  it "does not embed the script in the head when the user denies all cookies" do
    visit root_path

    page.execute_script <<~JS
      ui.consent.denyAll();
    JS

    within(:css, "head", visible: :hidden) do
      expect(page).not_to have_selector("script[src^='https://www.googletagmanager.com/gtm.js?id=GOOGLE_TAG_MANAGER_ID']", visible: :hidden)
    end
  end

  it "does not embed the script in the head when the user has not yet made a decision" do
    visit root_path

    within(:css, "head", visible: :hidden) do
      expect(page).not_to have_selector("script[src^='https://www.googletagmanager.com/gtm.js?id=GOOGLE_TAG_MANAGER_ID']", visible: :hidden)
    end
  end
end
