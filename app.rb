#!/usr/bin/env ruby

require "bundler/setup"
require "json"
require "sinatra"
require "sinatra/reloader" if development?


get "/" do
  erb :chart
end

get "/namespaces_by_cpu" do
  namespaces = JSON.parse(File.read("data/namespace-report.json"))

  values = namespaces["items"]
    .map { |n| [ n.fetch("name").to_s, n.dig("max_requests", "cpu").to_i ] }
    .sort_by { |i| i[1] }
    .reverse

  erb :namespaces_by_cpu, locals: { values: values }
end
