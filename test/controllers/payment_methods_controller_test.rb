require 'test_helper'

class PaymentMethodsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get payment_methods_index_url
    assert_response :success
  end

  test "should get update" do
    get payment_methods_update_url
    assert_response :success
  end

  test "should get create" do
    get payment_methods_create_url
    assert_response :success
  end

  test "should get destroy" do
    get payment_methods_destroy_url
    assert_response :success
  end

end
