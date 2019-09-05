#!/usr/bin/env ruby

require "bundler/setup"
require "json"
require "sinatra"
require "sinatra/reloader" if development?


get "/" do
  redirect "/namespaces_by_cpu"
end

get "/namespaces_by_cpu" do
  namespaces = JSON.parse(File.read("data/namespace-report.json"))

  values = namespaces["items"]
    .map { |n| [ n.fetch("name").to_s, n.dig("max_requests", "cpu").to_i, n.dig("resources_used", "cpu").to_i ] }
    .sort_by { |i| i[1] }
    .reverse

  column_titles = [
    "Namespaces",
    "CPU requested (millicores)",
    "CPU used (millicores)",
  ]

  locals = {
    values: values,
    column_titles: column_titles,
    title: "Namespaces by CPU (requested vs. used)",
  }

  erb :namespaces_by_cpu, locals: locals
end

get "/namespace/:name" do
  namespaces = JSON.parse(File.read("data/namespace-report.json"))
  data = namespaces["items"].find { |n| n["name"] == params[:name] }

  erb :namespace, locals: { data: data }
end
