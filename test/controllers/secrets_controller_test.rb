require 'test_helper'

class SecretsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @secret = secrets(:one)
  end

  test "should get index" do
    get secrets_url
    assert_response :success
  end

  test "should get new" do
    get new_secret_url
    assert_response :success
  end

  test "should create secret" do
    assert_difference('Secret.count') do
      post secrets_url, params: { secret: { address: @secret.address, city: @secret.city, doc_name: @secret.doc_name, doc_value: @secret.doc_value, due_date: @secret.due_date, name: @secret.name, neighborhood: @secret.neighborhood, plan_id: @secret.plan_id, secret: @secret.secret, secret_password: @secret.secret_password, state: @secret.state, wireless_password: @secret.wireless_password, wireless_ssid: @secret.wireless_ssid } }
    end

    assert_redirected_to secret_url(Secret.last)
  end

  test "should show secret" do
    get secret_url(@secret)
    assert_response :success
  end

  test "should get edit" do
    get edit_secret_url(@secret)
    assert_response :success
  end

  test "should update secret" do
    patch secret_url(@secret), params: { secret: { address: @secret.address, city: @secret.city, doc_name: @secret.doc_name, doc_value: @secret.doc_value, due_date: @secret.due_date, name: @secret.name, neighborhood: @secret.neighborhood, plan_id: @secret.plan_id, secret: @secret.secret, secret_password: @secret.secret_password, state: @secret.state, wireless_password: @secret.wireless_password, wireless_ssid: @secret.wireless_ssid } }
    assert_redirected_to secret_url(@secret)
  end

  test "should destroy secret" do
    assert_difference('Secret.count', -1) do
      delete secret_url(@secret)
    end

    assert_redirected_to secrets_url
  end
end
