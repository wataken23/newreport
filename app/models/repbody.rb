class Repbody < ActiveRecord::Base
#  attr_accessible :body, :date, :tag_id, :title, :user_id
  belongs_to :user
  belongs_to :tag
  has_many :comments
  has_many :usercomments
  has_many :updates
  has_many :hyperlinks
  accepts_nested_attributes_for :hyperlinks
private
def role_params
    params.require(:repbody).permit(:body, :date, :tag_id, :title, :user_id, :fix)
end
end
