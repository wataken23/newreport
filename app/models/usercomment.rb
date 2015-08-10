class Usercomment < ActiveRecord::Base
#  attr_accessible :body, :comment_id, :date, :repbody_id, :user_id
  belongs_to :repbody
  belongs_to :comment
  belongs_to :user
private
def role_params
    params.require(:usercomment).permit(:body, :comment_id, :date, :repbody_id, :user_id)
end
end
