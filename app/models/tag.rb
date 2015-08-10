class Tag < ActiveRecord::Base
#  attr_accessible :tag
  has_many :repbodies
private
def role_params
    params.require(:tag).permit(:tag, :deadline)
end
end
