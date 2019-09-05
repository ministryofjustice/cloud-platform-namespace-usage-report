#!/usr/bin/env ruby

require "bundler/setup"
require "json"
require "sinatra"
require "sinatra/reloader" if development?

JSON_FILE = "data/namespace-report.json"
NAMESPACES = JSON.parse(File.read(JSON_FILE))

def namespaces_data(order_by)
  values = NAMESPACES["items"]
    .map { |n| [ n.fetch("name").to_s, n.dig("max_requests", order_by).to_i, n.dig("resources_used", order_by).to_i ] }
    .sort_by { |i| i[1] }
    .reverse

  { values: values, last_updated: Time.now, type: order_by }
end

def namespace(name)
  NAMESPACES["items"].find { |n| n["name"] == params[:name] }
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

  locals = namespaces_data("cpu").merge(
    column_titles: column_titles,
    title: "Namespaces by CPU (requested vs. used)",
  )

  erb :namespaces_chart, locals: locals
end

get "/namespaces_by_memory" do
  column_titles = [
    "Namespaces",
    "Memory requested (mebibytes)",
    "Memory used (mebibytes)",
  ]

  locals = namespaces_data("memory").merge(
    column_titles: column_titles,
    title: "Namespaces by Memory (requested vs. used)",
  )

  erb :namespaces_chart, locals: locals
end

get "/namespace/:name" do
  erb :namespace, locals: { data: namespace(params[:name]) }
end
