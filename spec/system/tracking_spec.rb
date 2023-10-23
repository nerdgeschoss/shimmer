# frozen_string_literal: true

require "system_helper"

RSpec.describe "Tracking" do
  describe "Google Tag Manager" do
    let!(:gtm_script_selector) { "script[src^='https://www.googletagmanager.com/gtm.js?id=GOOGLE_TAG_MANAGER_ID']" }
    let!(:gtm_iframe_selector) { "noscript iframe[src^='https://www.googletagmanager.com/ns.html?id=GOOGLE_TAG_MANAGER_ID']" }

    it "embeds the script in the head when the user permits statistic tracking" do
      visit root_path

      page.execute_script <<~JS
        ui.consent.permitAll();
      JS

      within(:css, "head", visible: :hidden) do
        expect(page).to have_selector(gtm_script_selector, visible: :hidden)
      end

      within(:css, "body") do
        expect(page).to have_selector(gtm_iframe_selector, visible: :hidden)
      end
    end

    it "does not embed the script in the head when the user denies all cookies" do
      visit root_path

      page.execute_script <<~JS
        ui.consent.denyAll();
      JS

      within(:css, "head", visible: :hidden) do
        expect(page).not_to have_selector(gtm_script_selector, visible: :hidden)
      end

      within(:css, "body") do
        expect(page).not_to have_selector(gtm_iframe_selector, visible: :hidden)
      end
    end

    it "does not embed the script in the head when the user has not yet made a decision" do
      visit root_path

      within(:css, "head", visible: :hidden) do
        expect(page).not_to have_selector(gtm_script_selector, visible: :hidden)
      end

      within(:css, "body") do
        expect(page).not_to have_selector(gtm_iframe_selector, visible: :hidden)
      end
    end
  end
end
