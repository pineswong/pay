require 'test_helper'

class StaticControllerTest < ActionController::TestCase
  test "index" do
    get :index
    assert_response :success
    assert_template 'index'
    assert_select 'title', '缴费通'
 	end

end
