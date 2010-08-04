class QuestionsController < ApplicationController
  # GET /questions
  # GET /questions.xml
  before_filter :login_required

  padlock(:on => :index) {  current_user.isadmin? || (has_role? :surveyor, Survey.find(params[:id])) }
  padlock(:on => :edit) {  current_user.isadmin? || (has_role? :surveyor,Survey.find(params[:survey_id])) }
  padlock(:on => :new) { !(current_user.nil?) }
  padlock(:on => :create) { !(current_user.nil?) }
  padlock(:on => :update) { current_user.isadmin? || (has_role? :surveyor, Survey.find(params[:survey_id]))  }
  padlock(:on => :show) { current_user.isadmin? || (has_role? :surveyor, Survey.find(params[:id]))  }
  padlock(:on => :destroy) {  current_user.isadmin? || (has_role? :surveyor, Survey.find(params[:survey_id]))}
  padlock(:on => :enb_disb) { current_user.isadmin?}
  padlock(:on => :show_for_admin) { current_user.isadmin?}

  def show_for_admin
    @questions = Question.all
  end
  
  def index
    @i=0
    @surveys = Survey.find_by_id(params[:id])
    @question_surveys=QuestionSurvey.find(:all, :conditions => {:survey_id => params[:id]})
    @questions = [];
    @question_surveys.each do
      |q| 
      @questions.push(Question.find(:first, :conditions => {:id => q.id, :status => true}))
    end    
  end
  # GET /questions/1
  # GET /questions/1.xml
  def show
    @question = Question.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.xml
  def new
    @question=Question.new
    @qtid=params[:question][:questiontype_id]
#    puts @qtid
    @survey_id=params[:id]
    puts @survey_id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @question }
    end
  end

  # GET /questions/1/edit

   
  def edit
    @question = Question.find(params[:id])
    @survey_id = params[:survey_id]
  end


  # POST /questions
  # POST /questions.xml
  def create
   # @question = Question.new(params[:question])
    puts params[:id]
    @q1=Question.create(params[:question])
    if @q1.errors.empty?                # => false
      if !(@q1.id.nil?)
        QuestionSurvey.create({:question_id => @q1.id, :survey_id => params[:id]})
        flash[:notice] = 'Question Created,Create another one'
        puts "params[:id]"
        redirect_to :action => 'select_type', :id => params[:id]
      else
        @q2=Question.find(:first, :conditions => "question_details='#{params[:question][:question_details]}'")
        @qs1=QuestionSurvey.create({:question_id => @q2.id, :survey_id => params[:id]})
        flash[:notice] = 'Question Created,Create another one'
        puts "params[:id]"
        redirect_to :action => 'select_type', :id => params[:id]
      end
    else

      if params[:question][:questiontype_id] != "1"
        
        flash[:error] ="Question "+(@q1.errors.on(:question_details).to_s)
        flash[:error] ="Choice "+(@q1.errors.on(:choice_details).to_s)

        redirect_to :action => 'select_type', :id => params[:id]
      else
        flash[:error] ="Question "+(@q1.errors.on "question_details".to_s)

      redirect_to :action => 'select_type', :id => params[:id]
      end
    end   

  end

  # PUT /questions/1
  # PUT /questions/1.xml
  def update
    @question_surveys=QuestionSurvey.find(:all, :conditions => {:question_id => params[:id]}, :limit => 2)
    if @question_surveys.length > 1      #multiple surveys accessing the "question to be updated"
      @question_surveys=QuestionSurvey.find(:first, :conditions => {:question_id => params[:id], :survey_id => params[:survey_id]})
      QuestionSurvey.delete(@question_surveys.id)
      @q1=Question.create(params[:question])
      puts @q1
      if !(@q1.id.nil?)
        QuestionSurvey.create({:question_id => @q1.id, :survey_id => params[:survey_id]})
        flash[:notice] = 'Question Updated'
        redirect_to :controller => 'questions', :action => 'index', :id => params[:survey_id]
      else
        @q2=Question.find(:first, :conditions => "question_details='#{params[:question][:question_details]}'")
        @qs1=QuestionSurvey.create({:question_id => @q2.id, :survey_id => params[:survey_id]})
        flash[:notice] = 'Question Updated'
        redirect_to :controller => 'questions', :action => 'index', :id => params[:survey_id]
      end
    else
      puts params[:survey_id]
      @question = Question.find(params[:id])
      if @question.update_attributes(params[:question])  
        redirect_to :controller => 'questions', :action => 'index', :id => params[:survey_id]
      else 
        redirect_to :controller => 'questions', :action => 'index', :id => params[:survey_id]
      end 
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.xml
  def destroy
    if !current_user.isadmin?
      @question_surveys=QuestionSurvey.find(:first, :conditions => {:question_id => params[:id],:survey_id => params[:survey_id] })
      QuestionSurvey.delete(@question_surveys.id)
      @qias=QuestionSurvey.find(:first, :conditions => {:question_id => params[:id]}) #find if the question exist in another survey
      if @qias.nil?
        Question.delete(params[:id])                           # if it does not exist delete it from question table also
      end
      redirect_to :controller => 'questions', :action => 'index', :id => params[:survey_id]  
    else
      @question_surveys=QuestionSurvey.find(:first, :conditions => {:question_id => params[:id]})
      QuestionSurvey.delete(@question_surveys.id)
      Question.delete(params[:id])           
      redirect_to :action => 'show_for_admin'  
    end
      
  end

  def select_type
    @survey_id=params[:id]
  end

  def enb_disb
    @question=Question.find_by_id(params[:id])
    if @question.status == true
      @question.update_attributes(:status => false)      
    else
      @question.update_attributes(:status => true)
    end
    redirect_to :action => "show_for_admin"
  end

end
