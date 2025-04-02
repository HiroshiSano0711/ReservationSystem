require "test_helper"

class Admin::TeamBusinessSettingsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get admin_team_business_settings_show_url
    assert_response :success
  end

  test "should get edit" do
    get admin_team_business_settings_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_team_business_settings_update_url
    assert_response :success
  end
end
