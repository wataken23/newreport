# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
#  attr_accessible :account, :email, :grade, :password_digest, :role_id, :studentid, :username
#  attr_accessible :account, :email, :grade, :password, :role_id, :studentid, :username, :password_confirmation, :machine, :acception, :owner, :year, :furigana #, :password_digest
  mount_uploader :avatar, AvatarUploader
  belongs_to :role
  has_many :repbodies
  has_many :myfiles
  has_many :comments, :through => :repbodies
  has_many :usercomments, :through => :repbodies, :through => :comments
#=begin
  has_secure_password 
  validates_presence_of :password, :on => :create 
  validates :account, :presence => true, 
                      :uniqueness => true, 
                      :format => { :with => /(\w|\d)+/,
                                   :message => "は半角英数字で記入して下さい" }, 
                      :on => :create
  validates :username, :presence => true, :on => :create
  validates :furigana, :presence => true, :on => :create
  validates :role_id, :presence => true, :numericality => true, :on => :create
  validates :studentid, :presence => true, :numericality => true, :on => :create
  validates :grade, :presence => true,  
            :format => { :with => /\A[A-Z]\d\z/,
                         :message => "は '大文字アルファベット + 数字' で記入してください"
                       },
            :on => :create
  validates :machine, :presence => true,  
            :format => { :with => /\Ajoho[0-9][0-9]\z/,
                         :message => "は 'johoXX'(XX は 2 桁の数字) で記入してください"
                       },
            :on => :create
  validates :email, :presence => true,  
            :uniqueness => true, 
            :format => { :with => /\A\S*\S@\S*/,
                         :message => "がまちがっています．確認してください. "
                       },
            :on => :create
  validates :owner, :presence => true, 
	    if: :check_owner,
            :format => { :with => /(\w|\d)+/,
                         :message => "が間違っています．半角英数字で記入してください. "
                       },
            :on => :create
#=end
private
def check_owner
    if User.exists?(account: owner) 
     @ownerid = User.where(account: owner).pluck(:role_id)
       if @ownerid == [4]
	  errors.add(:owner, "にはTA, VTA, Staff のアカウントを入力してください")
       else
       end
    else 
	  errors.add(:owner, "にはTA, VTA, Staff のアカウントを正確に入力してください")      
    end
  end
def user_params
#    params.require(:user).permit(:account, :email, :grade, :password_digest, :role_id, :studentid, :username, :password_confirmation, :machine, :acception, :owner, :year, :furigana, :password_digest)
    params.require(:user).permit(:account, :email, :grade, :password_digest, :role_id, :studentid, :username, :password_confirmation, :machine, :acception, :owner, :year, :furigana)
end
end
