class Client < ActiveRecord::Base
  has_many :client_users
  has_many :parks
  has_many :plugins
end
