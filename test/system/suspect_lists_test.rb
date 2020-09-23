require "application_system_test_case"

class SuspectListsTest < ApplicationSystemTestCase
  setup do
    @suspect_list = suspect_lists(:one)
  end

  test "visiting the index" do
    visit suspect_lists_url
    assert_selector "h1", text: "Suspect Lists"
  end

  test "creating a Suspect list" do
    visit suspect_lists_url
    click_on "New Suspect List"

    fill_in "Company", with: @suspect_list.company_id
    fill_in "Delimiter", with: @suspect_list.delimiter
    fill_in "File", with: @suspect_list.file
    fill_in "Name", with: @suspect_list.name
    fill_in "User", with: @suspect_list.user_id
    click_on "Create Suspect list"

    assert_text "Suspect list was successfully created"
    click_on "Back"
  end

  test "updating a Suspect list" do
    visit suspect_lists_url
    click_on "Edit", match: :first

    fill_in "Company", with: @suspect_list.company_id
    fill_in "Delimiter", with: @suspect_list.delimiter
    fill_in "File", with: @suspect_list.file
    fill_in "Name", with: @suspect_list.name
    fill_in "User", with: @suspect_list.user_id
    click_on "Update Suspect list"

    assert_text "Suspect list was successfully updated"
    click_on "Back"
  end

  test "destroying a Suspect list" do
    visit suspect_lists_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Suspect list was successfully destroyed"
  end
end
