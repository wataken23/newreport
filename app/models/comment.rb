class Comment < ActiveRecord::Base
#  attr_accessible :body, :date, :user_id, :repbody_id
  belongs_to :repbody
  belongs_to :user
  has_many   :usercomments
private
def role_params
    params.require(:comment).permit(:body, :date, :user_id, :repbody_id)
end

end
