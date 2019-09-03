#!/usr/bin/env ruby

require "bundler/setup"
require "sinatra"
require "sinatra/reloader" if development?

get "/" do
  erb :chart
end
