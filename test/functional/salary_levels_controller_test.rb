require 'test_helper'

class SalaryLevelsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:salary_levels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create salary_level" do
    assert_difference('SalaryLevel.count') do
      post :create, :salary_level => { }
    end

    assert_redirected_to salary_level_path(assigns(:salary_level))
  end

  test "should show salary_level" do
    get :show, :id => salary_levels(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => salary_levels(:one).to_param
    assert_response :success
  end

  test "should update salary_level" do
    put :update, :id => salary_levels(:one).to_param, :salary_level => { }
    assert_redirected_to salary_level_path(assigns(:salary_level))
  end

  test "should destroy salary_level" do
    assert_difference('SalaryLevel.count', -1) do
      delete :destroy, :id => salary_levels(:one).to_param
    end

    assert_redirected_to salary_levels_path
  end
end
