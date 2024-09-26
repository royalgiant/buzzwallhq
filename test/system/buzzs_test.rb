require "application_system_test_case"

class BuzzsTest < ApplicationSystemTestCase
  setup do
    @buzz = buzzs(:one)
  end

  test "visiting the index" do
    visit buzzs_url
    assert_selector "h1", text: "Buzzs"
  end

  test "should create buzz" do
    visit buzzs_url
    click_on "New buzz"

    check "Approved" if @buzz.approved
    fill_in "Buzz term", with: @buzz.buzz_term_id
    fill_in "Thumbnail url", with: @buzz.thumbnail_url
    fill_in "Url", with: @buzz.url
    fill_in "User", with: @buzz.user_id
    fill_in "Wall", with: @buzz.wall_id
    click_on "Create Buzz"

    assert_text "Buzz was successfully created"
    click_on "Back"
  end

  test "should update Buzz" do
    visit buzz_url(@buzz)
    click_on "Edit this buzz", match: :first

    check "Approved" if @buzz.approved
    fill_in "Buzz term", with: @buzz.buzz_term_id
    fill_in "Thumbnail url", with: @buzz.thumbnail_url
    fill_in "Url", with: @buzz.url
    fill_in "User", with: @buzz.user_id
    fill_in "Wall", with: @buzz.wall_id
    click_on "Update Buzz"

    assert_text "Buzz was successfully updated"
    click_on "Back"
  end

  test "should destroy Buzz" do
    visit buzz_url(@buzz)
    click_on "Destroy this buzz", match: :first

    assert_text "Buzz was successfully destroyed"
  end
end
