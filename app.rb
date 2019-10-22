#!/usr/bin/env ruby

require "bundler/setup"
require "json"
require "sinatra"
require "sinatra/reloader" if development?

JSON_FILE = "data/namespace-report.json"

def namespaces
  JSON.parse(File.read(JSON_FILE))
end

def namespaces_data(order_by)
  values = namespaces["items"]
    .map { |n| namespace_values(n, order_by) }
    .sort_by { |i| i[1] }
    .reverse

  {
    values: values,
    last_updated: DateTime.parse(namespaces["last_updated"]),
    type: order_by,
    total_requested: total_requested_by_all_namespaces(order_by), # order_by is cpu|memory
  }
end

def namespace_values(namespace, order_by)
  [
    namespace.fetch("name").to_s,
    namespace.dig("max_requests", order_by).to_i,
    namespace.dig("resources_used", order_by).to_i
  ]
end

def namespace(name)
  namespaces["items"].find { |n| n["name"] == params[:name] }
end

def total_requested_by_all_namespaces(property)
  namespaces["items"].map { |ns| ns.dig("max_requests", property) }.map(&:to_i).sum
end

############################################################

get "/" do
  redirect "/namespaces_by_cpu"
end

get "/namespaces_by_cpu" do
  column_titles = [ "Namespaces", "CPU requested (millicores)", "CPU used (millicores)" ]

  locals = namespaces_data("cpu").merge(
    column_titles: column_titles,
    title: "Namespaces by CPU (requested vs. used)",
  )

  erb :namespaces_chart, locals: locals
rescue Errno::ENOENT
  erb :no_data
end

get "/namespaces_by_memory" do
  column_titles = [ "Namespaces", "Memory requested (mebibytes)", "Memory used (mebibytes)" ]

  locals = namespaces_data("memory").merge(
    column_titles: column_titles,
    title: "Namespaces by Memory (requested vs. used)",
  )

  erb :namespaces_chart, locals: locals
rescue Errno::ENOENT
  erb :no_data
end

get "/namespace/:name" do
  erb :namespace, locals: { data: namespace(params[:name]) }
rescue Errno::ENOENT
  erb :no_data
end

post "/update-data" do
  expected_key = ENV.fetch("API_KEY")
  provided_key = request.env.fetch("HTTP_X_API_KEY", "dontsetthisvalueastheapikey")

  if expected_key == provided_key
    payload = request.body.read
    File.open(JSON_FILE, "w") {|f| f.puts(payload)}
    status 200
  else
    status 403
  end
end
