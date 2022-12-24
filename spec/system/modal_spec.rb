# frozen_string_literal: true

require "system_helper"

RSpec.describe "Modal" do
  fixtures :all

  fit "opens and closes a modal" do
    puts "🟡  #{posts_path}"
    visit posts_path
    expect(page).to have_title "Posts"
    # expect(page).to have_link "Write New Post"
  end
end
