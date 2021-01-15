require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

ActiveRecord::Base.establish_connection(

    :adapter => 'sqlite3',
    :database => 'db/kickflip.sqlite3d'
)

# configure :development do 
#     set :database, 'sqlite3:db/kickflip.db'
# end

require_all './app'