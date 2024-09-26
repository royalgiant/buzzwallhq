require "application_system_test_case"

class BuzzTermsTest < ApplicationSystemTestCase
  setup do
    @buzz_term = buzz_terms(:one)
  end

  test "visiting the index" do
    visit buzz_terms_url
    assert_selector "h1", text: "Buzz terms"
  end

  test "should create buzz term" do
    visit buzz_terms_url
    click_on "New buzz term"

    fill_in "Frequency check", with: @buzz_term.frequency_check
    fill_in "Term", with: @buzz_term.term
    fill_in "User", with: @buzz_term.user_id
    click_on "Create Buzz term"

    assert_text "Buzz term was successfully created"
    click_on "Back"
  end

  test "should update Buzz term" do
    visit buzz_term_url(@buzz_term)
    click_on "Edit this buzz term", match: :first

    fill_in "Frequency check", with: @buzz_term.frequency_check
    fill_in "Term", with: @buzz_term.term
    fill_in "User", with: @buzz_term.user_id
    click_on "Update Buzz term"

    assert_text "Buzz term was successfully updated"
    click_on "Back"
  end

  test "should destroy Buzz term" do
    visit buzz_term_url(@buzz_term)
    click_on "Destroy this buzz term", match: :first

    assert_text "Buzz term was successfully destroyed"
  end
end
