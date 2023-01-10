# frozen_string_literal: true

require "system_helper"

RSpec.describe "Modal" do
  fixtures :all

  fit "opens and closes a modal" do
    visit posts_path
    expect(page).to have_content "Posts"
    expect(page).to have_link "Write New Post"

    click_on "Write New Post"
    sleep 0.1

    expect(page).to have_content "New Post"
    expect(page).to have_link "Cancel"

    click_on "Cancel"
    expect(page).not_to have_selector ".modal--open"
    # expect(page).not_to have_content "New Post"
  end
end
