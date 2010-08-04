require File.dirname(__FILE__) + '/../test_helper'

class SurveysControllerTest < ActionController::TestCase
  fixtures :surveys, :users
  test "should get index" do

    current_user = create_user
    session[:user_id] = current_user.id
    get :index
    assert_response :success
    assert_not_nil assigns(:surveys)
  end

  test "should get new" do

    current_user = create_user
    session[:user_id] = current_user.id
    get :new
    assert_response :success
  end

  test "should create survey" do
    current_user = create_user
    session[:user_id] = current_user.id
    current_user = create_user
    assert_difference('Survey.count') do
      post :create, :survey => {:user_id => current_user.id, :title => "dd", :description => "dd", :survey_category => "ddd" }
    end

    assert_redirected_to survey_path(assigns(:survey))
  end

  test "should show survey" do
    current_user = create_user
    session[:user_id] = current_user.id
    get :show, :id => surveys(:s1).to_param
    assert_response :success
  end

  test "should get edit" do
     create_user
    get :edit, :id => surveys(:s1).to_param
    assert_response :success
  end

  test "should update survey" do
    create_user
    put :update, :id => surveys(:s1).to_param, :survey => {:title => "ddd", :description => "dd", :survey_category => "ddd" }
    assert_redirected_to survey_path(assigns(:survey))
  end

  test "should destroy survey" do
    create_user
    assert_difference('Survey.count', -1) do
      delete :destroy, :id => surveys(:s1).to_param
    end

    assert_redirected_to surveys_path
  end

protected
  def create_user
   current_user = User.find_by_login('quentin')
    return current_user 
  end
end
