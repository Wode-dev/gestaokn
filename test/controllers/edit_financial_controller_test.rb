require 'test_helper'

class EditFinancialControllerTest < ActionDispatch::IntegrationTest
  test "should get edit_payment" do
    get edit_financial_edit_payment_url
    assert_response :success
  end

  test "should get confirm_payment" do
    get edit_financial_confirm_payment_url
    assert_response :success
  end

  test "should get edit_bill" do
    get edit_financial_edit_bill_url
    assert_response :success
  end

  test "should get confirm_bill" do
    get edit_financial_confirm_bill_url
    assert_response :success
  end

  test "should get edit_install" do
    get edit_financial_edit_install_url
    assert_response :success
  end

  test "should get confirm_install" do
    get edit_financial_confirm_install_url
    assert_response :success
  end

end
