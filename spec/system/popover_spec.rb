# frozen_string_literal: true

require "system_helper"

RSpec.describe "Popover" do
  fixtures :all

  it "opens and closes a popover" do
    visit posts_path
    expect(page).to have_link "Open popover"
    expect(page).not_to have_selector ".popover"
    expect(page).not_to have_content "This is a popover!"

    click_on "Open popover"
    expect(page).to have_selector ".popover"
    expect(page).to have_content "This is a popover!"

    find("h1", text: "Posts").click # Click somewhere outside the popover
    expect(page).not_to have_selector ".popover"
    expect(page).not_to have_content "This is a popover!"
  end
end
