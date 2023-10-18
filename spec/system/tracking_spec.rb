# frozen_string_literal: true

require "system_helper"

RSpec.describe "Tracking" do
  context "when the user has not consented to tracking" do
    before do
      visit root_path
    end

    it "embeds the Google Tag Manager script in the head" do
      within(:css, "head", visible: :hidden) do
        expect(page).not_to have_selector("script[src^='https://www.googletagmanager.com/gtm.js?id=GOOGLE_TAG_MANAGER_ID']", visible: :hidden)
      end
    end

    it "embeds the Google Tag Manager noscript tag at the beginning of the body" do
      within(:css, "body") do
        expect(page).not_to have_selector("noscript iframe[src^='https://www.googletagmanager.com/ns.html?id=GOOGLE_TAG_MANAGER_ID']", visible: :hidden)
      end
    end
  end

  context "when the user has consented to tracking" do
    before do
      visit root_path

      page.execute_script <<~JS
        ui.consent.enableGoogleTagManager('GOOGLE_TAG_MANAGER_ID');
      JS
    end

    it "embeds the Google Tag Manager script in the head" do
      within(:css, "head", visible: :hidden) do
        expect(page).to have_selector("script[src^='https://www.googletagmanager.com/gtm.js?id=GOOGLE_TAG_MANAGER_ID']", visible: :hidden)
      end
    end

    it "embeds the Google Tag Manager noscript tag at the beginning of the body" do
      within(:css, "body") do
        expect(page).to have_selector("noscript iframe[src^='https://www.googletagmanager.com/ns.html?id=GOOGLE_TAG_MANAGER_ID']", visible: :hidden)
      end
    end
  end
end
