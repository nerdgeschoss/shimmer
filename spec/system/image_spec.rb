require "system_helper"

RSpec.describe "Image" do
  fixtures :all

  it "allows loading attribute to specify lazy and eager loading" do
    visit posts_path
    click_on "Write New Post"
    attach_file("post_image", Rails.root.join("spec/fixtures/files/nerdgeschoss.jpg"))
    click_on "Save"
    expect(page).to have_css("img[loading=lazy]")
    expect(page).to have_css("img[loading=eager]")
  end
end
