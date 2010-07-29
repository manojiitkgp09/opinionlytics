class AdminController < ApplicationController
  def index
    @user=User.find_by_id(current_user.id)
  end

  def enable_survey
    @survey=Survey.find_by_id(params[:id])
    @survey.update_attributes(params[:enable])
  end

  def disable_survey
    @survey=Survey.find_by_id(params[:id])
    @survey.update_attributes(params[:enable])
  end

  def enable_question
    @qs=QuestionSurveys.find_by_id(params[:id])
    @qs.update_attributes(params[:enable])
  end
  
  def disable_question
    @qs=QuestionSurveys.find_by_id(params[:id])
    @qs.update_attributes(params[:enable])
  end


end
