class Update < ActiveRecord::Base
#  attr_accessible :comment, :date, :repbody_id
  belongs_to :repbody
private
def role_params
    params.require(:update).permit(:comment, :date, :repbody_id)
end
end
