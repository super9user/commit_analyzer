require 'test_helper'

class ApiConfigurationsControllerTest < ActionController::TestCase
  setup do
    @api_configuration = api_configurations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_configurations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_configuration" do
    assert_difference('ApiConfiguration.count') do
      post :create, api_configuration: { name: @api_configuration.name }
    end

    assert_redirected_to api_configuration_path(assigns(:api_configuration))
  end

  test "should show api_configuration" do
    get :show, id: @api_configuration
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @api_configuration
    assert_response :success
  end

  test "should update api_configuration" do
    patch :update, id: @api_configuration, api_configuration: { name: @api_configuration.name }
    assert_redirected_to api_configuration_path(assigns(:api_configuration))
  end

  test "should destroy api_configuration" do
    assert_difference('ApiConfiguration.count', -1) do
      delete :destroy, id: @api_configuration
    end

    assert_redirected_to api_configurations_path
  end
end
