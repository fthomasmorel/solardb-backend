require_relative 'request'
require 'sinatra/cross_origin'
require 'sinatra'
require 'date'

set :port, 8080
set :environment, :staging
set :protection, :except => [:json_csrf]
register Sinatra::CrossOrigin

configure do
  enable :cross_origin
end

before do
  content_type 'application/json'
end

get '/weather/day' do
    return 406 if !params[:date]
    date = params[:date]
    date = Date.parse(date)
    getWeatherForDay(date).to_json
end

get '/weather/month' do
    return 406 if !params[:date]
    date = params[:date]
    date = Date.parse(date)
    getWeatherForMonth(date).to_json
end

get '/weather/year' do
    return 406 if !params[:date]
    date = params[:date]
    date = Date.parse(date)
    getWeatherForYear(date).to_json
end

get '/weather/:criteria/day' do
    return 406 if !params[:date]
    date = params[:date]
    date = Date.parse(date)
    getWeatherCritieraForDay(params[:criteria], date).to_json
end

get '/weather/:criteria/month' do
    return 406 if !params[:date]
    date = params[:date]
    date = Date.parse(date)
    getWeatherCritieraForMonth(params[:criteria], date).to_json
end

get '/weather/:criteria/year' do
    return 406 if !params[:date]
    date = params[:date]
    date = Date.parse(date)
    getWeatherCritieraForYear(params[:criteria], date).to_json
end

get '/production/all' do
    getAllProduction().to_json
end

get '/production/day' do
    return 406 if !params[:date]
    date = params[:date]
    date = Date.parse(date)
    getProductionForDay(date).to_json
end

get '/production/month' do
    return 406 if !params[:date]
    date = params[:date]
    date = Date.parse(date)
    getProductionForMonth(date).to_json
end

get '/production/year' do
    return 406 if !params[:date]
    date = params[:date]
    date = Date.parse(date)
    getProductionForYear(date).to_json
end

get '/production/month/detail' do
    return 406 if !params[:date]
    date = params[:date]
    date = Date.parse(date)
    getProductionRecordForMonth(date).to_json
end

get '/production/year/detail' do
    return 406 if !params[:date]
    date = params[:date]
    date = Date.parse(date)
    getProductionRecordForYear(date).to_json
end

options "*" do
  response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
  200
end
