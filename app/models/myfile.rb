class Myfile < ActiveRecord::Base
#  attr_accessible :caption, :filename, :user_id
  belongs_to :user
private
def role_params
    params.require(:myfile).permit(:caption, :filename, :user_id)
end
end
