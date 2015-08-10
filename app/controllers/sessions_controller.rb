# -*- coding: utf-8 -*-
class SessionsController < ApplicationController
  skip_before_filter :check_logined 


  def new 
  end 

  def create 
    user = User.find_by_account(params[:account]) rescue nil
    if user.nil? 
      redirect_to login_path, :notice => "【メッセージ】アカウント名とパスワードを確認してもう一度やり直してください" 
    else
      if user.acception 
#       @thisyear = Year.where(default: 't')
#       @role = Role.where("position = ?", '受講生')
#       if @thisyear.year != user.year && user.role_id.to_i == @role.id.to_i
#           redirect_to login_path, :notice => "【メッセージ】過去年度の受講生はログイン出来ません" 
       if user && user.authenticate(params[:password]) 
#        if user && user.authenticate(params[:password]) 
          session[:user_id] = user.id 
          repbody = Repbody.find_by_user_id(user.id) 
          redirect_to mypage_path(user.id), :notice => "【メッセージ】ログインしました" 
          #      redirect_to user_repbody_path(user.id, repbody.user_id), :notice => "ログインしました" 
        else 
          redirect_to login_path, :notice => "【メッセージ】アカウント名とパスワードを確認してもう一度やり直してください" 
        end 
      else
        redirect_to login_path, :notice => "【メッセージ】このアカウントには保証人の承諾がありません"         
      end 
    end
  end
  
  def destroy 
    session[:user_id] = nil 
    redirect_to login_path, :notice => "【メッセージ】ログアウトしました" 
  end 



end

