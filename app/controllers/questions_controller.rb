class QuestionsController < ApplicationController
  # GET /questions
  # GET /questions.xml
  padlock(:on => :index) { has_global_role? :admin }
  padlock(:on => :edit) { has_role? :surveyor, Survey.find(params[:id])|| has_global_role? :admin}
  padlock(:on => :new) { has_role? :surveyor, Survey.new}
  padlock(:on => :create) { has_global_role? :surveyor, Survey.new}
  padlock(:on => :update) { has_role? :surveyor, Survey.find(params[:id]) || has_global_role? :admin}
  padlock(:on => :show) { has_role? :surveyor, Survey.find(params[:id]) || has_global_role? :admin}
  padlock(:on => :destroy) { has_role? :surveyor, Survey.find(params[:id]) || has_global_role? :admin}
  padlock(:on => :enb_disb) { has_global_role? :admin}

  def index
    @i=0
    @question_surveys=QuestionSurvey.find(:all, :conditions => {:survey_id => params[:id] })
    @questions=Question.new
    @question_surveys.each do
      |q| 
      @questions=Question.find(:first, :conditions => {:id => q.id})
    end    
=begin
@questions = QuestionSurvey.find(:all, :conditions => {:survey_id => params[:id]})
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @questions }
    end
  end
=end
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
 #   puts @survey_id
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
    @question = Question.new(params[:question])
    @q1=Question.create(params[:question])
    if @q1.errors.empty?                # => false
      if !(@q1.id.nil?)
        QuestionSurvey.create({:question_id => @q1.id, :survey_id => params[:id]})
        flash[:message] = 'Question Created,Create another one'
        redirect_to :action => 'selecttype', :id => params[:id]
      else
        @q2=Question.find(:first, :conditions => "question_details='#{params[:question][:question_details]}'")
        @qs1=QuestionSurvey.create({:question_id => @q2.id, :survey_id => params[:id]})
        flash[:message] = 'Question Created,Create another one'
        redirect_to :action => 'selecttype', :id => params[:id]
      end
    else
      flash[:qempty] =@q1.errors.on "question_details"  
      if params[:question][:questiontype_id]!=1
        flash[:cempty]=@q1.errors.on "choice_details"
        redirect_to :action => 'selecttype', :id => params[:id]
      else
      redirect_to :action => 'selecttype', :id => params[:id]
      end
    end   
=begin
    respond_to do |format|
      if @question.save
        format.html { redirect_to(@question, :notice => 'Question was successfully created.') }
        format.xml  { render :xml => @question, :status => :created, :location => @question }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
=end
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
        flash[:message] = 'Question Updated'
        redirect_to :controller => 'questions', :action => 'show', :id => params[:survey_id]
      else
        @q2=Question.find(:first, :conditions => "question_details='#{params[:question][:question_details]}'")
        @qs1=QuestionSurvey.create({:question_id => @q2.id, :survey_id => params[:survey_id]})
        flash[:message] = 'Question Updated'
        redirect_to :controller => 'questions', :action => 'show', :id => params[:survey_id]
      end
    else
      puts params[:survey_id]
      @question = Question.find(params[:id])
      if @question.update_attributes(params[:question])  
        redirect_to :controller => 'questions', :action => 'show', :id => params[:survey_id]
      else 
        redirect_to :controller => 'questions', :action => 'show', :id => params[:survey_id]
      end 
    end
=begin       
 @question = Question.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to(@question, :notice => 'Question was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
=end
  end

  # DELETE /questions/1
  # DELETE /questions/1.xml
  def destroy
  @question_surveys=QuestionSurvey.find(:first, :conditions => {:question_id => params[:id],:survey_id => params[:survey_id] })
    QuestionSurvey.delete(@question_surveys.id)
    @qias=QuestionSurvey.find(:first, :conditions => {:question_id => params[:id]}) #find if the question exist in another survey
    if @qias.nil?
      Question.delete(params[:id])                           # if it does not exist delete it from question table also
    end
    redirect_to :controller => 'questions', :action => 'show', :id => params[:survey_id]  
=begin
  @question = Question.find(params[:id])
    @question.destroy
    respond_to do |format|
      format.html { redirect_to(questions_url) }
      format.xml  { head :ok }
    end
=end
  end

  def selecttype
    @survey_id=params[:id]
  end

  def enb_disb
    @question=QuestionSurvey.find(:first, :survey_id => params[:survey_id] && :question_id => params[:question_id])
    @question.update_attributes(params[:status])
  end
end
