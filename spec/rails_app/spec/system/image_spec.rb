# frozen_string_literal: true

require "system_helper"

RSpec.describe "Image" do
  fixtures :all

  before do
    visit posts_path
    upload_image
  end

  it "allows loading attribute to specify lazy and eager loading" do
    expect(page).to have_css("img[loading=lazy]")
    expect(page).to have_css("img[loading=eager]")
  end

  it "calculates the height of the image" do
    perform_enqueued_jobs
    visit posts_path
    expect(page).to have_css("img[height='69']")
    expect(page).to have_css("img[width='200']")
  end

  it "validates attributes for lazy and eager loading images" do
    perform_enqueued_jobs
    visit posts_path
    expect(page).to have_css("img[loading=lazy][data-controller='thumb-hash']")
    expect(page).to have_css("img[loading=lazy][style='background-color: #D6D6D6; background-size: cover;']")
    expect(page).to have_css("img[loading=lazy][data-thumb-hash-preview-hash-value='f5070e02804376887966f699719bef4806']")

    expect(page).to have_css("img[loading=eager]:not([data-controller])")
    expect(page).to have_css("img[loading=eager]:not([style])")
    expect(page).to have_css("img[loading=eager]:not([data-thumb-hash-preview-hash-value])")
  end

  it "checks for webp format in image variants" do
    perform_enqueued_jobs
    img_srcset = find("img[loading=lazy]")["srcset"]
    expect(img_srcset).to include(".webp")
  end

  private

  def upload_image
    click_on "Write New Post"
    attach_file("post_image", Rails.root.join("spec/fixtures/files/nerdgeschoss.jpg"))
    click_on "Save"
  end
end
