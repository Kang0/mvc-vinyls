class UserVinyl < ActiveRecord::Base
  belongs_to :users
  belongs_to :vinyls

end
