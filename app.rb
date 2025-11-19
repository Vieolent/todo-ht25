require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'





# Routen /
get '/' do
    slim(:index)
end


