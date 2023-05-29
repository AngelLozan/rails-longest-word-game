require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert test: "New game"
    assert_selector '.d-flex.justify-content-around.mt-6 div.p-3.mb-2.bg-primary.text-white.border.border-dark.rounded.shadow', count: 10
  end

  test "Entering random word gets a response from server" do
    visit new_url
    fill_in "word", with: "hoafsdlkjasdf"
    click_on "play"
    # take_screenshot
    assert_text "Sorry"
    take_screenshot
  end

end
