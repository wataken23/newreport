# -*- coding: utf-8 -*-
class RepbodiesController < ApplicationController
  before_filter :user_checked, :except => ['index', 'show', 'indexyeartag']
  before_filter :edit_checked, :only => ['edit']
  before_filter :year_checked, :except => ['index','show', 'indexyeartag']

  # GET /repbodies
  # GET /repbodies.json
  def index
    @thisyear = Year.find_by(default: 't')
    @yearserch = params[:yearserch].to_i
    @years = Year.all
#    @years = Year.order("year DESC")
    @years = Year.order("updated_at DESC")
    @year_name = Array.new
    @years.each do |year|
      @year_name[year.id.to_i] = year.year.to_s
    end

    @tagserch = 0
    @tagserch = params[:tagserch].to_i
#    @tags = Tag.all
#    @tags = Tag.order("tag DESC")
    @tags = Tag.order("updated_at DESC")
    @tag_name = Array.new
    @tags.each do |tag|
      @tag_name[tag.id.to_i] = tag.tag.to_s
    end
    @tag_name.delete_at(0)

    params[:keywords] ||= ""
#    keyword_arrays = params[:keywords].gsub(/　/," ").split()
    keyword_arrays = params[:keywords].split()
    usermachines = User.arel_table[:machine]
    usermachines_sel = usermachines.matches("\%#{keyword_arrays[0]}\%")
    for i in 1...keyword_arrays.length
      usermachines_sel = usermachines_sel.or(usermachines.matches("\%#{keyword_arrays[i]}\%"))
    end
    logger.debug("SQL: #{User.where(usermachines_sel).to_sql}")
    @usermachinex = User.where(usermachines_sel).pluck(:id)
    @usernamex    = User.where(usermachines_sel).pluck(:id)

    @users = User.all
#    @keyword = params[:keyword]
#    @usernamex    = User.where(account: @keyword).pluck(:id)
#    @usermachinex = User.where(machine: @keyword).pluck(:id)
#    if @usermachinex == "[]" && @usernamex == "[]"
#       @userserch = 0
#    elsif @usermachinex != "[]" && @usernamex === "[]"
#       @userserch = User.where(machine: @keyword).pluck(:id)
#    elsif @usermachinex === "[]" && @usernamex != "[]"
#       @userserch = User.where(account: @keyword).pluck(:id)
#    else
#       @userserch = 99
#    end
    @usernameh = Hash::new
    @usermachineh = Hash::new
    @users.each do |user|
      @usernameh["#{user.id}"] = user.account
      @usermachineh["#{user.id}"] = user.machine 
    end

    if @tagserch != 0 && @yearserch != 0 
      if @keyword == ""
      @repbodies = Repbody.where(year: @year_name[@yearserch], tag_id: @tagserch).order(:updated_at).reverse_order
      @h1 = "#{@year_name[@yearserch]} 年度のタグ「#{@tag_name[@tagserch -1]}」のレポート一覧"
      else 
#      @repbodies = Repbody.where(year: @year_name[@yearserch], tag_id: @tagserch, user_id: @userserch)
      @repbodies = Repbody.where(year: @year_name[@yearserch], tag_id: @tagserch, user_id: [@usernamex, @usermachinex]).order(:updated_at).reverse_order
      @h1 = "#{@year_name[@yearserch]} 年度のタグ「#{@tag_name[@tagserch -1]}」のレポート検索結果"
      end
    elsif @tagserch == 0 && @yearserch != 0
      if @keyword == ""
      @repbodies = Repbody.where(year: @year_name[@yearserch]).order(:updated_at).reverse_order
      @h1 = "#{@year_name[@yearserch]} 年度のレポート一覧"      
      else
      @repbodies = Repbody.where(year: @year_name[@yearserch], user_id: [@usernamex, @usermachinex]).order(:updated_at).reverse_order

#      @repbodies = Repbody.where(year: @year_name[@yearserch], user_id: @userserch)#, order: 'updated_at DESC')
      @h1 = "#{@year_name[@yearserch]} 年度のレポート検索結果"      
      end
    elsif @tagserch != 0 && @yearserch == 0
      if @keyword == ""
      @repbodies = Repbody.where(tag_id: @tagserch).order(:updated_at).reverse_order
      @h1 = "全年度のタグ「#{@tag_name[@tagserch - 1]}」のレポート一覧"      
      else
      @repbodies = Repbody.where(tag_id: @tagserch, user_id: [@usernamex, @usermachinex]).order(:updated_at).reverse_order
#      @repbodies = Repbody.where(tag_id: @tagserch, user_id: @userserch)#, order: 'updated_at DESC')
      @h1 = "全年度のタグ「#{@tag_name[@tagserch - 1]}」のレポート検索結果"      
      end
    else
      if @keyword != ""
      @repbodies = Repbody.where(user_id: [@usernamex, @usermachinex]).order(:updated_at).reverse_order
      @h1 = "全レポートの検索結果"
      else
      @repbodies = Repbody.order(:updated_at).reverse_order
      @h1 = "全レポート一覧"
      end
    end

    @comment = Comment.all
#    @role = Role.find(:first, :conditions => ["position = ?", '受講生'])
    @roleh =Hash::new
    @roles = Role.all
    @roles.each do |role|
      @roleh["#{role.id}"] = role.position
    end
    respond_to do |format|
      format.html # index.html.erb   
      format.json { render json: @repbodies }
    end
  end

  def indexyeartag
    @thisyear = Year.find_by(default: 't')
    @yearserch = params[:yearserch].to_i
    @years = Year.all
    @years = Year.order("updated_at DESC")
    @year_name = Array.new
    @years.each do |year|
      @year_name[year.id.to_i] = year.year.to_s
    end

    @tagserch = 0
    @tagserch = params[:tagserch].to_i
#    @tags = Tag.all
#    @tags = Tag.order("tag DESC")
    @tags = Tag.order("updated_at DESC")
    @tag_name = Array.new
    @tags.each do |tag|
      @tag_name[tag.id.to_i] = tag.tag.to_s
    end
    @tag_name.delete_at(0)

    params[:keywords] ||= ""
#    keyword_arrays = params[:keywords].gsub(/　/," ").split()
    keyword_arrays = params[:keywords].split()
    usermachines = User.arel_table[:machine]
    usermachines_sel = usermachines.matches("\%#{keyword_arrays[0]}\%")
    for i in 1...keyword_arrays.length
      usermachines_sel = usermachines_sel.or(usermachines.matches("\%#{keyword_arrays[i]}\%"))
    end
    logger.debug("SQL: #{User.where(usermachines_sel).to_sql}")
    @usermachinex = User.where(usermachines_sel).pluck(:id)
    @usernamex    = User.where(usermachines_sel).pluck(:id)

    @users = User.all
    @usernameh = Hash::new
    @usermachineh = Hash::new
    @users.each do |user|
      @usernameh["#{user.id}"] = user.account
      @usermachineh["#{user.id}"] = user.machine 
    end

    if @tagserch != 0 && @yearserch != 0 
      if @keyword == ""
      @repbodies = Repbody.where(year: @year_name[@yearserch], tag_id: @tagserch)
      @h1 = "#{@year_name[@yearserch]} 年度のタグ「#{@tag_name[@tagserch -1]}」のレポート一覧"
      else 
      @repbodies = Repbody.where(year: @year_name[@yearserch], tag_id: @tagserch, user_id: [@usernamex, @usermachinex])
      @h1 = "#{@year_name[@yearserch]} 年度のタグ「#{@tag_name[@tagserch -1]}」のレポート検索結果"
      end
    elsif @tagserch == 0 && @yearserch != 0
      if @keyword == ""
      @repbodies = Repbody.where(year: @year_name[@yearserch])#, order: 'updated_at DESC')
      @h1 = "#{@year_name[@yearserch]} 年度のレポート一覧"      
      else
      @repbodies = Repbody.where(year: @year_name[@yearserch], user_id: [@usernamex, @usermachinex])
      @h1 = "#{@year_name[@yearserch]} 年度のレポート検索結果"      
      end
    elsif @tagserch != 0 && @yearserch == 0
      if @keyword == ""
      @repbodies = Repbody.where(tag_id: @tagserch)#, order: 'updated_at DESC')
      @h1 = "全年度のタグ「#{@tag_name[@tagserch - 1]}」のレポート一覧"      
      else
      @repbodies = Repbody.where(tag_id: @tagserch, user_id: [@usernamex, @usermachinex])
      @h1 = "全年度のタグ「#{@tag_name[@tagserch - 1]}」のレポート検索結果"      
      end
    else
#      if @keyword != ""
#      @repbodies = Repbody.where(user_id: @usernamex, user_id: @usermachinex)#.order(update_at: :DESC)
#      @h1 = "全レポートの検索結果"
#      else
      @repbodies = Repbody.order(updated_at: :DESC)
      @h1 = "レポート一覧"
#      end
    end

    @comment = Comment.all
    @roleh =Hash::new
    @roles = Role.all
    @roles.each do |role|
      @roleh["#{role.id}"] = role.position
    end
    respond_to do |format|
      format.html # index.html.erb   
      format.json { render json: @repbodies }
    end
  end

  # GET /repbodies/opinion
  # GET /repbodies/opinion.json
  def opinion
    @users = User.all
    @usernameh = Hash::new
    @users.each do |user|
      @usernameh["#{user.id}"] = user.username 
    end
    @tags = Tag.all
    @tag_name = Array.new
    @tags.each do |tag|
      @tag_name[tag.id.to_i] = tag.tag.to_s
    end
    @tag_name.delete_at(0)
    @repbodies = Repbody.find_all_by_tag_id(6, :order => 'updated_at DESC')
    @comment = Comment.all
    @role = Role.find(:first, :conditions => ["position = ?", '受講生'])
    respond_to do |format|
      format.html # opinion.html.erb   
      format.json { render json: @repbodies }
    end
  end

  # GET /repbodies/1
  # GET /repbodies/1.json
  def show
    @repbodyidshow = Repbody.find(params[:id])
#    @commentidshow = Comment.find(params[:id])
    @commentidshow = Comment.find_by(repbody_id: @repbodyidshow.id)
    @users = User.all
    @usernameh = Hash::new
    @users.each do |user|
      @usernameh["#{user.id}"] = user.username 
    end
    @tag = Tag.find(@repbodyidshow.tag_id)
    @comments = Comment.where(repbody_id: @repbodyidshow.id)
#    @usercomments = Usercomment.find_by(repbody_id: @repbodyidshow.id, comment_id: @commentidshow.id)
    @usercomments = Usercomment.where(repbody_id: @repbodyidshow.id)
    @updates = Update.where(repbody_id: @repbodyidshow.id)
    @hyperlinks = Hyperlink.where(repbody_id: @repbodyidshow.id)
    @urlhere = request.url
    @roleh =Hash::new
    @roles = Role.all
    @roles.each do |role|
      @roleh["#{role.id}"] = role.position
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @repbody }
    end
  end

  # GET /repbodies/new
  # GET /repbodies/new.json
  def new
    @repbody = Repbody.new
      @slink = Array.new
    for i in 1..5 do
      @hyperlink_#{i} = Hyperlink.new
      @slink << @hyperlink_#{i}
    end

#    @tag = Tag.all
    @thisyear = Year.find_by(default: 't')
    @yearname = @thisyear.year.to_s
#    @tag = Tag.find(:all, :conditions => [ "tag like ? ", '%2014%' ] )
    @tag = Tag.where("tag like ? ", "%[#{@yearname}]%" )

    if current_user.id
      @repbody.user_id = current_user.id
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @repbody }
    end
  end

  # GET /repbodies/1/edit
  def edit
    @repbody = Repbody.find(params[:id])
#    @tag = Tag.find(:all, :conditions => [ "tag like ? ", '%2014%' ] )
    @tag = Tag.all
      @slink = Array.new
    for i in 1..5 do
      @hyperlink_#{i} = Hyperlink.new
      @slink << @hyperlink_#{i}
    end

    @hyperlinks = Hyperlink.where(repbody_id: @repbody.id)

#    @repbodyu = Repbody.find_all_by_user_id(params[:id])
#    @repbody = @repbody.find(params[:id])
  end

  # POST /repbodies
  # POST /repbodies.json
  def create
    @repbody = Repbody.new(repbody_params)
#    @hyperlink = Hyperlink.new(params[:hyperlinks])
    @slink = params[:slink].to_a

#    @hyperlink1 = Hyperlink.new
#    @hyperlink2 = Hyperlink.new
#    @hyperlink3 = Hyperlink.new
#    @hyperlink1.attributes = {:link => "params[:hyperlinks[link[0]]]", :repbody_id => @repbody.id }
#    @hyperlink2.attributes = {:link => "params[:hyperlinks{link[1]]]", :repbody_id => @repbody.id }
#    @hyperlink3.attributes = {:link => "params[:hyperlinks[link[2]]]", :repbody_id => @repbody.id }
#    @hyperlinka = [@hyperlink1,@hyperlink2,@hyperlink3]
    
    @update = Update.new
    @current = Time.now
    @update.date = @current.strftime('%Y-%m-%d %H:%M:%S')
    @update.comment = "レポート新規作成"
    @repbody.date = @current.strftime('%Y-%m-%d %H:%M:%S')
    @thisyear = Year.find_by(default: 't')
    @repbody.year = @thisyear.year.to_i
    @repbody.fix = "t"
    respond_to do |format|
      if @repbody.save
        for i in 0...@slink.length do
          @hyperlink = Hyperlink.new
          @hyperlink.repbody_id = @repbody.id
          @hyperlink.link = @slink[i][1]['link'].to_s
          @hyperlink.title = @slink[i][1]['title'].to_s
          unless @hyperlink.link.empty?
            @hyperlink.save
          end
        end

        #        @hyperlink.repbody_id = @repbody.id
#        @hyperlink.save
#        @hyperlinka.each do |m|
#            m.save
#          end
        @update.repbody_id = @repbody.id
        @update.save
        if current_user.id
#          format.html { redirect_to user_repbody_path(current_user,@repbody.id), notice: "#{@slink} 【メッセージ】レポートを投稿しました." }
          format.html { redirect_to user_repbody_path(current_user,@repbody.id), notice: "【メッセージ】レポートを投稿しました." }
          #          format.html { redirect_to mypage_path(current_user.id), notice: 'Repbody was successfully created.' }
          format.json { render json: @repbody, status: :created, location: @repbody }
        else
          format.html { redirect_to @repbody, notice: 'Repbody was successfully created.' }
          format.json { render json: @repbody, status: :created, location: @repbody }
          #        format.html { redirect_to @repbody, notice: 'Repbody was successfully created.' }
          #        format.json { render json: @repbody, status: :created, location: @repbody }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @repbody.errors, status: :unprocessable_entity }
      end
      end
    end
    
    # PUT /repbodies/1
  # PUT /repbodies/1.json
  def update
    @repbody = Repbody.find(params[:id])
    @update = Update.new
    @current = Time.now
    @repbody.date = @current.strftime('%Y-%m-%d %H:%M:%S')
    @slink = params[:slink].to_a

#    rescue ActiveRecord::StaleObjectError

    respond_to do |format|
      if @repbody.update_attributes!(repbody_params)
        @update.date = @current.strftime('%Y-%m-%d %H:%M:%S')
        @update.comment = "レポート更新"
        @update.repbody_id = @repbody.id
        @update.save

        for i in 0...@slink.length do
          @hyperlink = Hyperlink.new
          @hyperlink.repbody_id = @repbody.id
          @hyperlink.link = @slink[i][1]['link'].to_s
          @hyperlink.title = @slink[i][1]['title'].to_s
          unless @hyperlink.link.empty?
            @hyperlink.save
          end
        end
        format.html { redirect_to [current_user, @repbody ], notice: "【メッセージ】レポートを更新しました." }
        format.json { head :no_content }

      else
        format.html { render action: "edit" }
        format.json { render json: @repbody.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repbodies/1
  # DELETE /repbodies/1.json
  def destroy
    @repbody = Repbody.find(params[:id])
    @repbody.destroy

    respond_to do |format|
      format.html { redirect_to repbodies_url }
      format.json { head :no_content }
    end
  end

  private 
  def user_checked 
    unless params[:user_id].to_i == current_user.id or current_user.id == "1"
      redirect_to mypage_path(current_user.id) , :notice => "【警告】他のユーザーのレポートに編集等を加えることはできません" 
    end 
  end 
  def edit_checked 
    @repbody = Repbody.find(params[:id])
    unless @repbody.user_id.to_i == current_user.id or current_user.id == "1"
      redirect_to mypage_path(current_user.id) , :notice => "【警告】他のユーザーのレポートに編集等を加えることはできません"
    end 
  end 
  def year_checked
    @thisyear = Year.find_by(default: 't')
    @role = Role.find_by("position = ?", '受講生')
    if @thisyear.year != current_user.year && current_user.role_id.to_i == @role.id.to_i
      redirect_to mypage_path(current_user.id) , :notice => "【警告】 今年度以外の受講生の新規作成・編集は許可されていません" 
    end 
  end 
  def repbody_params
#    params.require(:repbody).permit(:repbody, :comment_id, :usercomment_id, :account, :username, :user_id, :tag_id, :title, :body, :commentexis)
    params.require(:repbody).permit(:account, :username, :user_id, :tag_id, :title, :body, :commentexis, :year_id, :year, :usercomment, :comment, :tag, :fix, :deadline)
  end
end
