require "test_helper"

class BuzzTermsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @buzz_term = buzz_terms(:one)
  end

  test "should get index" do
    get buzz_terms_url
    assert_response :success
  end

  test "should get new" do
    get new_buzz_term_url
    assert_response :success
  end

  test "should create buzz_term" do
    assert_difference("BuzzTerm.count") do
      post buzz_terms_url, params: { buzz_term: { frequency_check: @buzz_term.frequency_check, term: @buzz_term.term, user_id: @buzz_term.user_id } }
    end

    assert_redirected_to buzz_term_url(BuzzTerm.last)
  end

  test "should show buzz_term" do
    get buzz_term_url(@buzz_term)
    assert_response :success
  end

  test "should get edit" do
    get edit_buzz_term_url(@buzz_term)
    assert_response :success
  end

  test "should update buzz_term" do
    patch buzz_term_url(@buzz_term), params: { buzz_term: { frequency_check: @buzz_term.frequency_check, term: @buzz_term.term, user_id: @buzz_term.user_id } }
    assert_redirected_to buzz_term_url(@buzz_term)
  end

  test "should destroy buzz_term" do
    assert_difference("BuzzTerm.count", -1) do
      delete buzz_term_url(@buzz_term)
    end

    assert_redirected_to buzz_terms_url
  end
end
