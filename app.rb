#!/usr/bin/env ruby

require "bundler/setup"
require "sinatra"

get "/" do
  erb :chart
end
