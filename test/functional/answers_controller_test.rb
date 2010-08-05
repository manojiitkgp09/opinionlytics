require File.dirname(__FILE__) + '/../test_helper'

class AnswersControllerTest < ActionController::TestCase
  fixtures :surveys, :users, :questions, :answers, :question_surveys
 
 test "should get show_for_response" do
    session[:user_id] = users(:old_password_holder).id
    current_user = session[:user_id]
    get :show_for_response
    assert_response :success
    survey = [] 
    survey.push(surveys(:s1))
    surveys = []
    surveys.push(surveys(:s1))
    surveys.push(surveys(:s2))
    assert_equal  survey, assigns("survey")
    assert_equal surveys, assigns(:surveys)
  end

  test "should redirect show_for_response" do
    session[:user_id] = users(:aaron).id
    current_user = session[:user_id]
    get :show_for_response
    assert_nil assigns("survey.first")
    assert_redirected_to "/users" 
    assert_equal 'There is no survey to which you can respond', flash[:error] 
  end

  test "should get answerq" do
    session[:user_id] = users(:quentin).id
    current_user = session[:user_id]
    get :answerq, {'id' => "#{surveys(:s1).id}"}
    assert_response :success
    i = 0
    survey_id = surveys(:s1).id
    question_surveys = []
    question_surveys.push(question_surveys(:two))
    question_surveys.push(question_surveys(:one))
    assert_equal assigns(:i), i
    assert_equal assigns(:survey_id), survey_id.to_s
    assert_equal assigns(:question_surveys), question_surveys
    assert_not_nil assigns(:i)
    assert_not_nil assigns(:survey_id)
    assert_not_nil assigns(:question_surveys)
  end

  test "should create response" do
    session[:user_id] = users(:quentin).id
    current_user = session[:user_id]
    q1 = questions(:one).id.to_s 
    q2 = questions(:two).id.to_s
    q = { "1" => q1 , "2" => q2 }
    qtype = {}
    atext = {}
    matext = {}
    qtype[q1] = questions(:one).questiontype_id.to_s
    qtype[q2] = questions(:two).questiontype_id.to_s
    atext[q1] = "skjuhdhduh"
    atext[q2] = "c1"
    assert_difference('Answer.count') do
      post :saveresponse, {:survey_id => surveys(:s1).id, :question_id => q, :questiontype_id => qtype , :answer_text => atext}
    end
    assert_response :success
    assert_not_nil assigns(:q1)
    assert_not_nil assigns(:answer)
  end

end



