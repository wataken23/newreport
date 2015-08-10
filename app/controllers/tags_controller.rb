# -*- coding: utf-8 -*-
class TagsController < ApplicationController
before_filter :edit_check
require 'time'

  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tags }
    end
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    @tag = Tag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tag }
    end
  end

  # GET /tags/new
  # GET /tags/new.json
  def new
    @tag = Tag.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tag }
    end
  end

  # GET /tags/1/edit
  def edit
    @tag = Tag.find(params[:id])
  end

  # POST /tags
  # POST /tags.json
  def create
    @tag = Tag.new(tag_params)

    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag, notice: 'タグが正しく作成されました' }
        format.json { render json: @tag, status: :created, location: @tag }
      else
        format.html { render action: "new" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tags/1
  # PUT /tags/1.json
  def update
    @tag = Tag.find(params[:id])
    @deadline = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(tag_params)
        format.html { redirect_to @tag, notice: 'タグが正しくアップデートされました' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to tags_url }
      format.json { head :no_content }
    end
  end
end
  private
  def edit_check
    @roles = Role.all
    @role = Hash.new
    @roles.each do |role|
      @role["#{role.id}"] = role.position 
    end
    if @role["#{current_user.role_id}"] == '受講生' 
      redirect_to mypage_path(current_user.id) , :notice => "受講生がタブの作成・編集することはできません" 
    end 
  end 
  def tag_params
   params.require(:tag).permit(:tag, :deadline, :created_at, :updated_at, :repbody)
  end
