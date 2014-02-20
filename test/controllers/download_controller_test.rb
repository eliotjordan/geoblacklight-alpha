require 'test_helper'

class DownloadControllerTest < ActionController::TestCase
  test "should get shapefile" do
    get :shapefile
    assert_response :success
  end

  test "should get kml" do
    get :kml
    assert_response :success
  end

end
