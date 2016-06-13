require 'test_helper'

class FuelsControllerTest < ActionController::TestCase
	def setup
		@fuel = fuels(:pinewong)
	end

  test 'index' do
    get :index
    assert_template 'index'
  end

  test 'new' do
    get :new
    assert_template 'new'
  end

  test 'edit' do
    get :edit, id: @fuel.id
    assert_template 'edit'
  end

  test 'show' do
    get :show, id: @fuel.id
    assert_template 'show'
  end

  test "create" do
    post :create, fuel: { number: @fuel.number, unit: @fuel.unit, name: @fuel.name }
    assert_redirected_to fuels_url
    assert_not flash[:success].empty?

    # 失败
    post :create, fuel: {number: '', unit: '', name: ''}
    assert_template 'new'
    assert_not flash[:danger].empty?
  end

  test 'update' do
    patch :update, id: @fuel.id, fuel: { number: @fuel.number, unit: @fuel.unit, name: @fuel.name }
    assert_redirected_to fuels_url
    assert_not flash[:success].empty?

    # 失败
    patch :update, id: @fuel.id, fuel: {number: ''}
    assert_template 'edit'
    assert_not flash[:danger].empty?
  end

  test "destroy" do
    delete :destroy, id: @fuel.id
    assert_redirected_to fuels_url
    assert_not flash[:success].empty?

    # # 失败
    # delete :destroy, id: @fuel.id
    # assert_template 'index'
    # assert_not flash[:danger].empty?
  end
end
