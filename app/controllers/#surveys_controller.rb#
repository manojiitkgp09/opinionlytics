class SurveysController < ApplicationController
  # GET /surveys
  # GET /surveys.xml
  before_filter :login_required


  padlock(:on => :edit) { (has_role? :surveyor, Survey.find(params[:id])) || current_user.isadmin? }
  padlock(:on => :new) { !current_user.nil?}
  padlock(:on => :create) { !current_user.nil?}
  padlock(:on => :update) { (has_role? :surveyor, Survey.find(params[:id])) || current_user.isadmin? }
  padlock(:on => :show) { (has_role? :surveyor, Survey.find(params[:id])) ||  current_user.isadmin? }
  padlock(:on => :destroy) { current_user.isadmin? || (has_role? :surveyor, Survey.find(params[:id]))  }
  padlock(:on => :enb_disb) { current_user.isadmin? }

  def index
   
    if current_user && !current_user.isadmin?
      @surveys = Survey.find_user_surveys(current_user.id)
    elsif current_user && current_user.isadmin?
      @surveys = Survey.find(:all)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @surveys }
    end
  end

  # GET /surveys/1
  # GET /surveys/1.xml
  def show
    if !(current_user.isadmin?)
      @survey = Survey.find(:all,  :conditions => {:status => true, :id => params[:id]})
    else
      @survey = Survey.find(:all,  :conditions => {:id => params[:id]})
    end
    puts "#{@survey}--------#{@survey.class}"
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @survey }
    end
  end

  # GET /surveys/new
  # GET /surveys/new.xml
  def new
    @survey = Survey.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @survey }
    end
  end

  # GET /surveys/1/edit
  def edit
    @survey = Survey.find(params[:id])
  end

  # POST /surveys
  # POST /surveys.xml
  def create
    @survey = Survey.new(params[:survey])
    
    respond_to do |format|
      if @survey.save
        current_user.has_role :surveyor, @survey
        format.html { redirect_to(@survey, :notice => 'Survey was successfully created.') }
        format.xml  { render :xml => @survey, :status => :created, :location => @survey }
      else
        flash[:error] = "Title can't be blank"
        format.html { render :action => "new" }
        format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /surveys/1
  # PUT /surveys/1.xml
  def update
    @survey = Survey.find(params[:id])

    respond_to do |format|
      if @survey.update_attributes(params[:survey])
        format.html { redirect_to(@survey, :notice => 'Survey was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.xml
  def destroy
    @survey = Survey.find(params[:id])
    @user = User.find_by_id(@survey.user_id)
    @survey.question_surveys.destroy_all
    
    @survey.destroy
    if @survey.destroy
      @user.has_no_role "surveyor", @survey
       
    else
      flash[:error]="Survey could not be deleted"
    end

    respond_to do |format|
      format.html { redirect_to(surveys_url) }
      format.xml  { head :ok }
    end
  end

  def enb_disb
    @survey=Survey.find_by_id(params[:id])
    if @survey.status==false
      params[:status] = true
    else
      params[:status] = false
    end
    @survey.update_attributes(:status => params[:status])
    redirect_to :action => "index"
  end



end
