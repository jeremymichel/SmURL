require 'sinatra'
require "sinatra/activerecord"

class Url < ActiveRecord::Base
end

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
    puts params[:url]
    @shortened = shorten_url
    @url = Url.new(long_url: params[:url], token: @shortened)
    if @url.save
      puts @url.inspect
      erb :index
    end
  end
end

get '/:short/?' do
  puts Url.find_by_token(params[:short])
  if url = Url.find_by_token(params[:short])
    redirect url.long_url
  else
    @error = "No URL found with the token : #{params[:short]}"
    erb :index
  end
end
