class Hyperlink < ActiveRecord::Base
#  attr_accessible :link, :repbody_id
  belongs_to :repbody
private
def role_params
    params.require(:hyperlink).permit(:link, :repbody_id)
end
end
