class Admin::UsersController < ApplicationController
  def index
    @users = User.find(:all, :order => :role_id)
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @users }
    end
  end
  
  def show
    @user = User.find(params[:id])
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @user }
    end
  end
  
  def new
    @user = User.new
    
    respond_to do |format|
      format.html
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
        flash[:notice] = "User #{@user.username} was successfully created."
        format.html { redirect_to(:action => :index) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.role.can_administer? && @user.id != session[:user_id]
        flash[:notice] = "Cannot update another administrator."
        format.html { redirect_to(:action=>:index) }
      elsif @user.update_attributes(params[:user])
        flash[:notice] = "User #{@user.username} was successfully updated."
        format.html { redirect_to(:action=>:index) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if !@user.role.can_administer?
      @user.destroy
    end

    respond_to do |format|
      format.html { redirect_to(admin_users_url) }
    end
  end
end
