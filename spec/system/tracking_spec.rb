require "system_helper"

RSpec.describe "Tracking" do
  describe "Google Tag Manager" do
    let!(:gtm_script_selector) { "script[src^='https://www.googletagmanager.com/gtm.js?id=GOOGLE_TAG_MANAGER_ID']" }
    let!(:gtm_iframe_selector) { "noscript iframe[src^='https://www.googletagmanager.com/ns.html?id=GOOGLE_TAG_MANAGER_ID']" }

    context "when the user permits statistic tracking" do
      before do
        visit root_path

        page.execute_script <<~JS
          ui.consent.permitted = ["statistic"];
        JS
      end

      it "appends the script in the head" do
        within(:css, "head", visible: :hidden) do
          expect(page).to have_selector(gtm_script_selector, visible: :hidden)
        end
      end

      it "prepends the script in the body" do
        within(:css, "body") do
          expect(page).to have_selector(gtm_iframe_selector, visible: :hidden)
        end
      end
    end

    context "when the denies statistic tracking" do
      before do
        visit root_path

        page.execute_script <<~JS
          ui.consent.permitted = ["essential", "targeting"];
        JS
      end

      it "does not append the script in the head" do
        within(:css, "head", visible: :hidden) do
          expect(page).not_to have_selector(gtm_script_selector, visible: :hidden)
        end
      end

      it "does not prepend the script in the body" do
        within(:css, "body") do
          expect(page).not_to have_selector(gtm_iframe_selector, visible: :hidden)
        end
      end
    end

    context "when the user has not given any consent" do
      before do
        visit root_path
      end

      it "does not append the script in the head" do
        within(:css, "head", visible: :hidden) do
          expect(page).not_to have_selector(gtm_script_selector, visible: :hidden)
        end
      end

      it "does not prepend the script in the body" do
        within(:css, "body") do
          expect(page).not_to have_selector(gtm_iframe_selector, visible: :hidden)
        end
      end
    end
  end
end
