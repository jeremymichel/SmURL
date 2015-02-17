require 'sinatra'
require 'data_mapper'

DataMapper.setup :default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/dev.db"

class Url
  include DataMapper::Resource
   property :id, Serial
   property :url, String
   property :short, String
end

DataMapper.auto_migrate!

helpers do
  def shorten_url
    (Time.now.to_i + rand(36**8)).to_s 36
  end
end

get '/' do
  erb :index
end

post '/' do
  unless (params[:url] =~ URI.regexp).nil?
    @shortened = shorten_url
    if @url = Url.create(url: params[:url], short: @shortened)
      erb :index
    end
  end
end

get '/:short/?' do
  if long_url = Url.first(short: params[:short])
    redirect long_url.url
  else
    @error = "No URL found with the token : #{params[:short]}"
    erb :index
  end
end
