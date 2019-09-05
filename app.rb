#!/usr/bin/env ruby

require "bundler/setup"
require "json"
require "sinatra"
require "sinatra/reloader" if development?

JSON_FILE = "data/namespace-report.json"
NAMESPACES = JSON.parse(File.read(JSON_FILE))

def ordered_data(order_by)
  NAMESPACES["items"]
    .map { |n| [ n.fetch("name").to_s, n.dig("max_requests", order_by).to_i, n.dig("resources_used", order_by).to_i ] }
    .sort_by { |i| i[1] }
    .reverse
end

get "/" do
  redirect "/namespaces_by_cpu"
end

get "/namespaces_by_cpu" do
  column_titles = [
    "Namespaces",
    "CPU requested (millicores)",
    "CPU used (millicores)",
  ]

  locals = {
    values: ordered_data("cpu"),
    column_titles: column_titles,
    title: "Namespaces by CPU (requested vs. used)",
  }

  erb :namespaces_chart, locals: locals
end

get "/namespaces_by_memory" do
  column_titles = [
    "Namespaces",
    "Memory requested (mebibytes)",
    "Memory used (mebibytes)",
  ]

  locals = {
    values: ordered_data("memory"),
    column_titles: column_titles,
    title: "Namespaces by Memory (requested vs. used)",
  }

  erb :namespaces_chart, locals: locals
end

get "/namespace/:name" do
  namespaces = JSON.parse(File.read("data/namespace-report.json"))
  data = namespaces["items"].find { |n| n["name"] == params[:name] }

  erb :namespace, locals: { data: data }
end
