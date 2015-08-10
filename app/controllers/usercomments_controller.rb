# -*- coding: utf-8 -*-
class UsercommentsController < ApplicationController

before_filter :edit_check, :only => ['edit']

  # GET /usercomments
  # GET /usercomments.json
  def index
    @usercomments = Usercomment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @usercomments }
    end
  end

  # GET /usercomments/1
  # GET /usercomments/1.json
  def show
    @usercomment = Usercomment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @usercomment }
    end
  end

  # GET /usercomments/new
  # GET /usercomments/new.json
  def new
    @usercomment = Usercomment.new
    @repbody = Repbody.find(params[:repbody_id])
    @comment = Comment.find(params[:comment_id])
    @usercomment.repbody_id = @repbody.id
    @usercomment.comment_id = @comment.id
    @user = User.find(@repbody.user_id)
    @usercomment.user_id = current_user.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @usercomment }

#    @repbody.commentexis = "ok"
#    @repbody.save
    end
  end

  # POST /usercomments
  # POST /usercomments.json
  def create
    @usercomment = Usercomment.new(usercomment_params)
    @comment = Comment.find(params[:comment_id])
    @repbody = Repbody.find(params[:repbody_id])
    @commentusername = User.find(@comment.user_id)
    @repbody.commentexis = "ok"
    @repbody.save
    @users = User.all
    @update = Update.new
    @current = Time.now
    @usercomment.date = @current.strftime('%Y-%m-%d %H:%M:%S')
    respond_to do |format|
      if @usercomment.save
        @update.date = @current.strftime('%Y-%m-%d %H:%M:%S')
        @update.comment = "コメント返信 For [#{@comment.user.username}]"
        @update.repbody_id = @repbody.id
#        @update.comment_id = @usercomment.id
        @update.save
        format.html { redirect_to user_repbody_path(@repbody.user_id, @repbody.id), :notice => '【メッセージ】コメントは正しく付与されました.' }
        format.json { render json: @usercomment, status: :created, location: @usercomment }
      else
        format.html { render action: "new" }
        format.json { render json: @usercomment.errors, status: :unprocessable_entity }

      end
    end
  end

  # GET /usercomments/1/edit
  def edit
    @usercomment = Usercomment.find(params[:id])
    @repbody = Repbody.find(params[:repbody_id])
    @usercomment.repbody_id = @repbody.id
    @user = User.find(@repbody.user_id)
    @usercomment.user_id = current_user.id
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # PUT /usercomments/1
  # PUT /usercomments/1.json
  def update
    @usercomment = Usercomment.find(params[:id])
    @comment = Comment.find(params[:id])
    @repbody = Repbody.find(params[:repbody_id])
    @update = Update.new
    @current = Time.now
    @usercomment.date = @current.strftime('%Y-%m-%d %H:%M:%S')
    respond_to do |format|
      if @usercomment.update_attributes(params[:usercomment])
        @update.date = @current.strftime('%Y-%m-%d %H:%M:%S')
        @update.comment = "コメント返信 For [#{@current_user.account}  -> #{@comment.user_id}]"
        @update.repbody_id = @repbody.id
        @update.save
        format.html { redirect_to mypage_path(current_user.id), :notice => '【メッセージ】コメントは正しく更新されました.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @usercomment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usercomments/1
  # DELETE /usercomments/1.json
  def destroy
    @usercomment = Usercomment.find(params[:id])
    @usercomment.destroy

    respond_to do |format|
      format.html { redirect_to usercomments_url }
      format.json { head :no_content }
    end
  end
#=begin
  private
  def edit_check
    @repbody = Repbody.find(params[:id])
#     @repbody = Repbody.find(params[:repbody_id])
#    @role = Role.find(:first, :conditions => ["position = ?", '受講生'])
    unless @repbody.user_id.to_i == current_user.id
#    if current_user.id.to_i == @repbody.user_id.to_i
       #current_user.id.to_i == @user.id.to_i
       #      repbody = Repbody.find(current_user.id)
      redirect_to mypage_path(current_user.id) , :notice => "【注意】レポート投稿者以外のコメント返信は許可されていません."
    end
  end
  #=end
  def usercomment_params
      params.require(:usercomment).permit(:usercomment, :repbody_id, :user_id, :comment_id, :body, :username, :account)
  end
end
