# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
before_filter :check_if_login, :only => 'new'

  def check_if_login
    if current_user
     puts "----CAME HERE----"
      if current_user.isadmin?
        redirect_to :controller => 'admin', :action => 'index'
      else
        puts "came here"
        redirect_to :controller => 'users', :action => 'index'
      end
    else
      render :action => 'new'
    end
  end
  # render new.erb.html
  def new
  end

  def create
    @app=App.new
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      if current_user.isadmin?
        redirect_back_or_default('/admin/index/')
      else
        redirect_back_or_default('/users/')
      end
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/login')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
