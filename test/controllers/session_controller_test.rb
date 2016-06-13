require 'test_helper'

class SessionControllerTest < ActionController::TestCase
  def setup
    @admin = users(:admin)
  end

  test 'new' do
    get :new
    assert_template 'new'
  end

  test "create" do
    post :create, session: { username: 'admin', password: 'admin' }
    assert_redirected_to root_url
    assert_not flash[:success].empty?

    # 失败
    post :create, session: { username: '', password: '' }
    assert_template 'new'
    assert_not flash[:danger].empty?
  end

  test "destroy" do
    delete :destroy
    assert_redirected_to root_url
    assert_not flash[:success].empty?
  end

end
