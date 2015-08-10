class Role < ActiveRecord::Base
#  attr_accessible :position
  has_many :users
private
def role_params
    params.require(:role).permit(:position)
end
end

