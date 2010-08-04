class AnswersController < ApplicationController

before_filter :login_required

  def show_for_response
    @surveys = Survey.find_by_sql("select * from surveys where user_id <> #{current_user.id}")
@survey=[]
    @surveys.each do |s|
      if ((Answer.find(:first, :conditions => {:survey_id => s.id, :user_id => current_user.id }).nil?) && !(QuestionSurvey.find(:first, :conditions => { :survey_id => s.id }).nil?))
                        @survey.push(s) 
                      end
                                        
    end
    if @survey.first.nil? 
      flash[:error]="There is no survey to which you can respond"
      redirect_back_or_default("/users")
    end
  end
  
  def answerq
    @i=0
    @survey_id=params[:id]
    @question_surveys=QuestionSurvey.find(:all, :conditions => {:survey_id => params[:id] })
    if @question_surveys.first.nil?
        flash[:error] = "No Survey found"
      redirect_to :action => 'answer', :controller => 'surveys'
    end    
  end
  
  def saveresponse
    @answer=Answer.create(:user_id => current_user.id, :survey_id => params[:survey_id])
    for j in params[:question_id].values 
      @question_answer=AnswerQuestion.new
      puts "#{params[:questiontype_id][:j]}#######"
     if (params[:questiontype_id][j] != '3')
       @q1=AnswerQuestion.create(:answer_id => @answer.id, :question_id => j, :answer_text => params[:answer_text][j])
     else
       params[:m_answer_text][j].each_value do |record|
          if record!="0"
            @q1=AnswerQuestion.create(:answer_id => @answer.id, :question_id => j, :answer_text => record)
          end
        end
     end
      if @q1.nil?
        chk=1
        break
      else
        chk=0
      end
    end
    if chk==0
      flash[:notice] = "Thank you for completing the survey"
    else
      flash[:error] = "There are some unfilled responses"
      
    end
  end
  
  def showresponse

    @compsurvey=Answer.find(:all, :conditions => {:user_id => current_user.id})
    if @compsurvey.first.nil?
      flash[:message] = "No Entries found"
      redirect_to :action => 'index', :controller => 'users'
    end
    @survey=[]
    i=0
    @compsurvey.each do
      |record|
      @survey[i]=Survey.find(:first, :conditions => {:id => record.survey_id})
      i=i+1
    end
  end
  
  def showresponsea
    @i=0
    puts params
    if params[:id].nil?
      @survey_id=params[:survey][:id]
    else 
      @survey_id=params[:id]
    end
    puts "#{@survey_id}#########"
    @question_surveys=QuestionSurvey.find(:all, :conditions => {:survey_id => @survey_id })
    if params[:id].nil?
      @response_survey=Answer.find(:first, :conditions => {:user_id => session[:id], :survey_id => params[:survey][:id]})
    else 
      @response_survey=Answer.find(:first, :conditions => {:user_id => session[:id], :survey_id => params[:id]})
    end
    @final_responses=AnswerQuestion.find(:all, :conditions => {:answer_id => @response_survey.id})
  end
  
  def delete
    @question_surveys=QuestionSurvey.find(:first, :conditions => {:question_id => params[:id],:survey_id => params[:survey_id] })
    QuestionSurvey.delete(@question_surveys.id)
    @qias=QuestionSurvey.find(:first, :conditions => {:question_id => params[:id]}) #find if the question exist in another survey
    if @qias.nil?
      Question.delete(params[:id])                           # if it does not exist delete it from question table also
    end
    redirect_to :controller => 'questions', :action => 'show', :id => params[:survey_id]
  end
  
  def editresponse
    @survey_id=params[:survey_id]
    @response=AnswerQuestion.find(:all, :conditions => {:question_id => params[:question_id], :answer_id => params[:id]})
    puts @response
  end

  def updateresponse
    if params[:questiontype_id] !='3'
      @response=AnswerQuestion.find(:first, :conditions => {:question_id => params[:answer][:question_id], :answer_id => params[:answer][:answer_id]})
      @response.update_attributes(params[:answer])
      flash[:message] = "Your Response is Updated"
      redirect_to :action => 'showresponsea', :controller => 'questions', :id => params[:survey][:id]
    else 
      @response=AnswerQuestion.find(:all, :conditions => {:question_id => params[:answer][:question_id], :answer_id => params[:answer][:answer_id]})
      puts @response.class
      if @response.class.to_s == "Array"
        @response.each do |r|
        AnswerQuestion.delete(r.id)
       end
      else 
        AnswerQuestion.delete(@response.id)
      end
      for i in params[:m_answer_text].values
        if i!='0'
          res=AnswerQuestion.new
          res.question_id=params[:answer][:question_id]
          res.answer_id=params[:answer][:answer_id]
          res.answer_text=i
          res.save
        end
      end
      flash[:message] = "Your Response is Updated"
      redirect_to :action => 'showresponsea', :controller => 'questions', :id => params[:survey][:id]
    end
  end

  # GET /answers
  # GET /answers.xml
  def index
      
  end    


  # GET /answers/1
  # GET /answers/1.xml
  def show
    @i=0
    @survey_id=params[:id]
    @question_surveys=QuestionSurvey.find(:all, :conditions => {:survey_id => params[:id] })
    if @question_surveys.first.nil?
        flash[:message] = "No Survey found"
      redirect_to :action => 'answer', :controller => 'surveys'
    end      

  end

  # GET /answers/new
  # GET /answers/new.xml
  def new
    @answer = Answer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @answer }
    end
  end

  # GET /answers/1/edit
  def edit
    @answer = Answer.find(params[:id])
  end

  # POST /answers
  # POST /answers.xml
  def create
    @answer=Answer.create(:user_id => current_user.id, :survey_id => params[:survey_id])
    for j in params[:question_id].values 
      @question_answer=AnswerQuestion.new
      puts "#{params[:questiontype_id][:j]}#######"
      if (params[:questiontype_id][j] != '3')
        @q1=AnswerQuestion.create(:answer_id => @answer.id, :question_id => j, :answer_text => params[:answer_text][j])
      else
        params[:m_answer_text][j].each_value do |record|
          if record!="0"
            @q1=AnswerQuestion.create(:answer_id => @answer.id, :question_id => j, :answer_text => record)
          end
        end
      end
      if @q1.nil?
        chk=1
        break
      else
        chk=0
      end
    end
    if chk==0
      flash[:notice] = "Thank you for completing the survey"
    else
      flash[:error] = "There are some unfilled responses"
      
    end
    
    
  end
  
  # PUT /answers/1
  # PUT /answers/1.xml
  def update
    @answer = Answer.find(params[:id])

    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        format.html { redirect_to(@answer, :notice => 'Answer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @answer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.xml
  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to(answers_url) }
      format.xml  { head :ok }
    end
  end
end
