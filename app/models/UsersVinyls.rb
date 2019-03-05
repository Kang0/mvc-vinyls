class UsersVinyls < ActiveRecord::Base
  belongs_to :users
  belongs_to :vinyls

end
