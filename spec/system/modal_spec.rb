require "system_helper"

RSpec.describe "Modal" do
  fixtures :all

  it "opens and closes a modal" do
    visit posts_path
    expect(page).to have_content "Posts"
    expect(page).to have_link "Write New Post"
    expect(page).not_to have_selector ".modal--open"
    expect(page).not_to have_content "Compose Post"

    click_on "Write New Post"
    expect(page).to have_selector ".modal--open"
    expect(page).to have_selector ".modal--custom-size"
    expect(page).to have_content "Compose Post"
    expect(page).to have_link "Cancel"

    click_on "Cancel"
    expect(page).not_to have_selector ".modal--open"
    expect(page).not_to have_content "Compose Post"
  end
end
