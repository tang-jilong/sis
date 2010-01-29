require 'test_helper'

class SalariesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:salaries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create salary" do
    assert_difference('Salary.count') do
      post :create, :salary => { }
    end

    assert_redirected_to salary_path(assigns(:salary))
  end

  test "should show salary" do
    get :show, :id => salaries(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => salaries(:one).to_param
    assert_response :success
  end

  test "should update salary" do
    put :update, :id => salaries(:one).to_param, :salary => { }
    assert_redirected_to salary_path(assigns(:salary))
  end

  test "should destroy salary" do
    assert_difference('Salary.count', -1) do
      delete :destroy, :id => salaries(:one).to_param
    end

    assert_redirected_to salaries_path
  end
end
