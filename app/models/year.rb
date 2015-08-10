class Year < ActiveRecord::Base
#  attr_accessible :year, :default
private
def year_params
    params.require(:year).permit(:year, :default)
end
end
