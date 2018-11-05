require "application_system_test_case"

class SecretsTest < ApplicationSystemTestCase
  setup do
    @secret = secrets(:one)
  end

  test "visiting the index" do
    visit secrets_url
    assert_selector "h1", text: "Secrets"
  end

  test "creating a Secret" do
    visit secrets_url
    click_on "New Secret"

    fill_in "Address", with: @secret.address
    fill_in "City", with: @secret.city
    fill_in "Doc Name", with: @secret.doc_name
    fill_in "Doc Value", with: @secret.doc_value
    fill_in "Due Date", with: @secret.due_date
    fill_in "Name", with: @secret.name
    fill_in "Neighborhood", with: @secret.neighborhood
    fill_in "Plan", with: @secret.plan
    fill_in "Secret", with: @secret.secret
    fill_in "Secret Password", with: @secret.secret_password
    fill_in "State", with: @secret.state
    fill_in "Wireless Password", with: @secret.wireless_password
    fill_in "Wireless Ssid", with: @secret.wireless_ssid
    click_on "Create Secret"

    assert_text "Secret was successfully created"
    click_on "Back"
  end

  test "updating a Secret" do
    visit secrets_url
    click_on "Edit", match: :first

    fill_in "Address", with: @secret.address
    fill_in "City", with: @secret.city
    fill_in "Doc Name", with: @secret.doc_name
    fill_in "Doc Value", with: @secret.doc_value
    fill_in "Due Date", with: @secret.due_date
    fill_in "Name", with: @secret.name
    fill_in "Neighborhood", with: @secret.neighborhood
    fill_in "Plan", with: @secret.plan
    fill_in "Secret", with: @secret.secret
    fill_in "Secret Password", with: @secret.secret_password
    fill_in "State", with: @secret.state
    fill_in "Wireless Password", with: @secret.wireless_password
    fill_in "Wireless Ssid", with: @secret.wireless_ssid
    click_on "Update Secret"

    assert_text "Secret was successfully updated"
    click_on "Back"
  end

  test "destroying a Secret" do
    visit secrets_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Secret was successfully destroyed"
  end
end
