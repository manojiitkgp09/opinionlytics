class AdminController < ApplicationController
   before_filter :login_required
  padlock(:on => :all) { current_user.isadmin? }
  def index
    @user=User.find_by_id(current_user.id)
  end

  def manage_users
    @users=User.find_by_sql("select * from users where (id <> #{current_user.id}) and state <> 'deleted'")
  end

  def edit_role
    @roles=User.find_current_roles(params[:id])
  end


end
