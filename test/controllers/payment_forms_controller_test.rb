require 'test_helper'

class PaymentFormsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get payment_forms_index_url
    assert_response :success
  end

  test "should get update" do
    get payment_forms_update_url
    assert_response :success
  end

  test "should get create" do
    get payment_forms_create_url
    assert_response :success
  end

  test "should get destroy" do
    get payment_forms_destroy_url
    assert_response :success
  end

end
