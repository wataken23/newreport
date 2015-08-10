# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  skip_before_filter :check_logined, :only => ['newext', 'createext']
  before_filter :edit_check, :only => ['new', 'create', 'edit', 'destroy', 'acception']
  before_filter :mypage_check, :only => ['mypage', 'chpass', 'show']

  # GET /users
  # GET /users.json
  def index
    @thisyear = Year.find_by(default: 't')
    @yearserch = params[:yearserch].to_i
#    @years = Year.all
    @years = Year.order("year DESC")
    @year_name = Array.new
    @years.each do |year|
      @year_name[year.id.to_i] = year.year.to_s
    end
#    @year_name.delete_at(0)
    @users = User.all
    @roles = Role.all
    @role = Hash::new
    @roles.each do |role|
      @role["#{role.id}"] = role.position 
    end

    params[:keywords] ||= ""
#    keyword_arrays = params[:keywords].gsub(/　/," ").split()
    keyword_arrays = params[:keywords].split()
#    usermachines = User.arel_table[:machine].pluck(:id)
    usermachines = User.arel_table[:machine]
    usermachines_sel = usermachines.matches("\%#{keyword_arrays[0]}\%")
    for i in 1...keyword_arrays.length
      usermachines_sel = usermachines_sel.or(usermachines.matches("\%#{keyword_arrays[i]}\%"))
    end
    logger.debug("SQL: #{User.where(usermachines_sel).to_sql}")
    @usermachinex = User.where(usermachines_sel).pluck(:id)

    @keyword = params[:keyword]
    @usernamex    = User.where(account: @keyword).pluck(:id)
#    @usermachinex = User.where(machine: @keyword).pluck(:id)
    if @yearserch != 0
       if @keyword == ""
          @users = User.where(year: @year_name[@yearserch]).order(:machine)
          @h1 = "#{@year_name[@yearserch]} 年度のユーザ一覧"
       else
          @users = User.where(year: @year_name[@yearserch], id: @usernamex, id: @usermachinex).order(:machine)
          @h1 = "#{@year_name[@yearserch]} 年度のユーザ検索"
       end
    else
#       if @keyword == ""
          @users = User.where(year: @thisyear.year.to_i).order(:machine)#, :order => 'studentid DESC')
          @h1 = "#{@thisyear.year.to_i} 年度ユーザ一覧"
#       else
#          @users = User.where(year: @thisyear.year.to_i, id: @usernamex, id: @usermachinex)#, :order => 'studentid DESC')
#          @users = User.find(:all)#, :order => 'studentid DESC')
#          @h1 = "#{@thisyear.year.to_i} 年度ユーザ検索"
#       end 
    end
    @user_waiting = User.where(acception: 'f', owner: current_user.account.to_s )
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def indexyear
    params[:keywords] ||= ""
#    keyword_arrays = params[:keywords].gsub(/　/," ").split()
    keyword_arrays = params[:keywords].split()
#    usermachines = User.arel_table[:machine].pluck(:id)
    usermachines = User.arel_table[:machine]
    usermachines_sel = usermachines.matches("\%#{keyword_arrays[0]}\%")
    for i in 1...keyword_arrays.length
      usermachines_sel = usermachines_sel.or(usermachines.matches("\%#{keyword_arrays[i]}\%"))
    end
    logger.debug("SQL: #{User.where(usermachines_sel).to_sql}")
    @usermachinex = User.where(usermachines_sel).pluck(:id)

    @keyword = params[:keyword]
    @usernamex    = User.where(account: @keyword).pluck(:id)
#    @usermachinex = User.where(machine: @keyword).pluck(:id)
    @yearserch = params[:yearserch].to_i
#    @years = Year.all
    @years = Year.order("year DESC")
    @year_name = Array.new
    @years.each do |year|
      @year_name[year.id.to_i] = year.year.to_s
    end
#    @year_name.delete_at(0)
    @users = User.all
    @roles = Role.all
    @role = Hash::new
    @roles.each do |role|
      @role["#{role.id}"] = role.position 
    end
    if @yearserch != 0
       if @keyword == ""
          @users = User.where(year: @year_name[@yearserch]).order(:machine)
          @h1 = "#{@year_name[@yearserch]} 年度のユーザ一覧"
       else
          @users = User.where(year: @year_name[@yearserch], id: @usernamex, id: @usermachinex).order(:machine)
          @h1 = "#{@year_name[@yearserch]} 年度のユーザ検索"
       end
    else
       if @keyword == ""
          @users = User.all.order(:machine)
          @h1 = "全年度ユーザ一覧"
       else
          @users = User.where(id: @usernamex, id: @usermachinex).order(:machine)
          @h1 = "全年度ユーザ検索"
       end 
    end

    @user_waiting = User.where(acception: 'f', owner: current_user.account.to_s)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @role = Role.find(@user.role_id)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    @role = Role.all
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  def newext
    @user = User.new
    @role = Role.all
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
#    @role = Role.find(@user.role_id)
    @role = Role.all
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @role = Role.all
    @thisyear = Year.find_by(default: 't')
    @user.year = @thisyear.year.to_i
    @user.acception = 't'
#    respond_to do |format|
      if @user.save
#        @repbody = @user.create_repbody( :user_id => @user.id )
        redirect_to users_path, :notice => '【メッセージ】ユーザは正しく作成されました.'
      else
        render "new"
      end
    end

  def createext
    @user = User.new(user_params)
    @role = Role.all
    @thisyear = Year.find_by(default: 't')
    @owner = User.find_by(account: @user.owner)
    @user.year = @thisyear.year.to_i
    @user.acception = 'f'
    @user.role_id = 4

#    respond_to do |format|
      if @user.save
        mail = Usermail.newuser(@owner.username, @user.username, @owner.email, @user.email)
        mail.deliver
        render 'accept' and return
        redirect_to users_path, :notice => '【メッセージ】ユーザ登録申請をしました.' and return
      else
        render 'newext'
#        format.html { render action: "new" }
#        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
#      else
#        render 'newext'
#        format.html { render action: "new" }
#        format.json { render json: @user.errors, status: :unprocessable_entity }
#     end
    end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to @user, notice: '【メッセージ】ユーザ情報は正しく更新されました.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def mypage
    @user = User.find(params[:id])
    @roles = Role.all
    @tag = Tag.all
    @repbody = Repbody.where(user_id: params[:id])
    @tag_name = Array.new
    @tag.each do |tag|
      @tag_name[tag.id.to_i] = tag.tag.to_s
    end
    @tag_name.delete_at(0)
    @role = Hash::new
    @roles.each do |role|
      @role["#{role.id}"] = role.position 
    end

    @thisyear = Year.find_by(default: 't')
    @year_name = Array.new
    @year_name = @thisyear.year.to_i
    @user1 = User.all
    @user2 = User.all
    if @user.machine == "joho03"
      @machine1 =  "joho01"
      @machine2 =  "joho02"
      @user1 = User.where(year: @year_name, machine: @machine1)#@machine1 @machine2)#.order(machine)
      @user2 = User.where(year: @year_name, machine: @machine2)#@machine1 @machine2)#.order(machine)
    elsif @user.machine == "joho06"
      @machine1 =  "joho04"
      @machine2 =  "joho05"
      @user1 = User.where(year: @year_name, machine: @machine1)#@machine1 @machine2)#.order(machine)
      @user2 = User.where(year: @year_name, machine: @machine2)#@machine1 @machine2)#.order(machine)
    elsif @user.machine == "joho09"
      @machine1 =  "joho07"
      @machine2 =  "joho08"
      @user1 = User.where(year: @year_name, machine: @machine1)#@machine1 @machine2)#.order(machine)
      @user2 = User.where(year: @year_name, machine: @machine2)#@machine1 @machine2)#.order(machine)
    elsif @user.machine == "joho12"
      @machine1 =  "joho10"
      @machine2 =  "joho11"
      @user1 = User.where(year: @year_name, machine: @machine1)#@machine1 @machine2)#.order(machine)
      @user2 = User.where(year: @year_name, machine: @machine2)#@machine1 @machine2)#.order(machine)
    elsif @user.machine == "joho15"
      @machine1 =  "joho13"
      @machine2 =  "joho14"
      @user1 = User.where(year: @year_name, machine: @machine1)#@machine1 @machine2)#.order(machine)
      @user2 = User.where(year: @year_name, machine: @machine2)#@machine1 @machine2)#.order(machine)
    elsif @user.machine == "joho18"
      @machine1 =  "joho16"
      @machine2 =  "joho17"
      @user1 = User.where(year: @year_name, machine: @machine1)#@machine1 @machine2)#.order(machine)
      @user2 = User.where(year: @year_name, machine: @machine2)#@machine1 @machine2)#.order(machine)
    elsif @user.machine == "joho27" or @user.machine == "joho21"
      @machine1 =  "joho19"
      @machine2 =  "joho20"
      @user1 = User.where(year: @year_name, machine: @machine1)#@machine1 @machine2)#.order(machine)
      @user2 = User.where(year: @year_name, machine: @machine2)#@machine1 @machine2)#.order(machine)
    else @user.machine == "joho24"
      @machine1 =  "joho22"
      @machine2 =  "joho23"
      @user1 = User.where(year: @year_name, machine: @machine1)#@machine1 @machine2)#.order(machine)
      @user2 = User.where(year: @year_name, machine: @machine2)#@machine1 @machine2)#.order(machine)
    end

#    if current_user.id.to_i == params[:id].to_i
    respond_to do |format|
      format.html # mypage.html.erb
      format.json { render json: @user }
#      end
    end
  end
  def userreportshow
    @user = User.find(params[:id])
    @role = Role.find(@user.role_id)
    @tag = Tag.all
    @repbody = Repbody.where(user: params[:id])
    @tag_name = Array.new
    @tag.each do |tag|
      @tag_name[tag.id.to_i] = tag.tag.to_s
    end
    @tag_name.delete_at(0)
    respond_to do |format|
      format.html # mypage.html.erb
      format.json { render json: @user }
    end
  end

  def chpass
    @user = User.find(params[:id])
#    @role = Role.find(@user.role_id)
    @role = Role.all
    @role = Hash::new
    @roles.each do |role|
      @role["#{role.id}"] = role.position
    end
  end

  def acception
    @user = User.find(params[:id])
    @user.acception = 't'
    @owner = User.find_by_account(@user.owner)
    respond_to do |format|
      if @user.save
        mail = Usermail.accepteduser(@owner.username, @user.username, @owner.email, @user.email)
        mail.deliver
        format.html { redirect_to users_url, notice: '【メッセージ】ユーザを承認しました' }
        format.json { head :no_content }
      else
        format.html { render action: "index" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
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
      redirect_to mypage_path(current_user.id) , :notice => "【警告】受講生が他のユーザー情報の編集等をすることはできません" 
    end 
  end 
  def mypage_check
    @roles = Role.all
    @role = Hash.new
    @roles.each do |role|
      @role["#{role.id}"] = role.position 
    end
    if current_user.id.to_i != params[:id].to_i && @role["#{current_user.role_id}"] == '受講生' 
      redirect_to mypage_path(current_user.id) , :notice => "【警告】受講生が他のユーザー情報の編集等をすることはできません" 
    end 
  end 
  def user_params
    params.require(:user).permit(:user, :account, :email, :grade, :password, :role_id, :studentid, :username, :password_confirmation, :machine, :acception, :owner, :year, :furigana, :avatar, :avatar_chace, :remove_avatar)
  end
end
