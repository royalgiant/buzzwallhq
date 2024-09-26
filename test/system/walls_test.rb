require "application_system_test_case"

class WallsTest < ApplicationSystemTestCase
  setup do
    @wall = walls(:one)
  end

  test "visiting the index" do
    visit walls_url
    assert_selector "h1", text: "Walls"
  end

  test "should create wall" do
    visit walls_url
    click_on "New wall"

    fill_in "Buzz term", with: @wall.buzz_term_id
    fill_in "Iframe url", with: @wall.iframe_url
    fill_in "Name", with: @wall.name
    check "Published" if @wall.published
    fill_in "User", with: @wall.user_id
    click_on "Create Wall"

    assert_text "Wall was successfully created"
    click_on "Back"
  end

  test "should update Wall" do
    visit wall_url(@wall)
    click_on "Edit this wall", match: :first

    fill_in "Buzz term", with: @wall.buzz_term_id
    fill_in "Iframe url", with: @wall.iframe_url
    fill_in "Name", with: @wall.name
    check "Published" if @wall.published
    fill_in "User", with: @wall.user_id
    click_on "Update Wall"

    assert_text "Wall was successfully updated"
    click_on "Back"
  end

  test "should destroy Wall" do
    visit wall_url(@wall)
    click_on "Destroy this wall", match: :first

    assert_text "Wall was successfully destroyed"
  end
end
