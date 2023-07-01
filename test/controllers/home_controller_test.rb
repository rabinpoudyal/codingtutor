require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_index_url
    assert_response :success
  end

  test "should get services" do
    get home_services_url
    assert_response :success
  end

  test "should get projects" do
    get home_projects_url
    assert_response :success
  end

  test "should get pricing" do
    get home_pricing_url
    assert_response :success
  end

  test "should get contacts" do
    get home_contacts_url
    assert_response :success
  end

  test "should get abouat" do
    get home_abouat_url
    assert_response :success
  end
end
