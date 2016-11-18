require_relative 'parser'
require 'parseconfig'
require 'mongo'
require 'date'

config = ParseConfig.new('/var/solardb/etl.conf')
db = Mongo::Client.new(["#{config['DB_HOST']}:#{config['DB_PORT']}"], :database => config['DB_NAME'])

year = Date.today.strftime("%Y").to_i
month = Date.today.strftime("%m").to_i
day = Date.today.strftime("%d").to_i

airquality = parseAirQuality(config['AQCITY'])
sunshine = parseSunshineRate(config['MCCITY'], day-1, month, year)
weather = parseWeather(config['YHCITY'])

db[:air].insert_one({:date => Date.today, :quality => airquality}) if airquality > 0
db[:sun].insert_one({:date => Date.today, :sunshine => sunshine}) if sunshine > 0
db[:weather].insert_one(weather.to_json)

puts db[:weather].find.to_a.to_json
