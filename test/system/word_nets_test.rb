require "application_system_test_case"

class WordNetsTest < ApplicationSystemTestCase
  setup do
    @word_net = word_nets(:one)
  end

  test "visiting the index" do
    visit word_nets_url
    assert_selector "h1", text: "Word Nets"
  end

  test "creating a Word net" do
    visit word_nets_url
    click_on "New Word Net"

    fill_in "Keyword", with: @word_net.keyword
    click_on "Create Word net"

    assert_text "Word net was successfully created"
    click_on "Back"
  end

  test "updating a Word net" do
    visit word_nets_url
    click_on "Edit", match: :first

    fill_in "Keyword", with: @word_net.keyword
    click_on "Update Word net"

    assert_text "Word net was successfully updated"
    click_on "Back"
  end

  test "destroying a Word net" do
    visit word_nets_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Word net was successfully destroyed"
  end
end
