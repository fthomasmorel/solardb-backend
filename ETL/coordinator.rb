require_relative 'parser'
require 'parseconfig'
require 'mongo'
require 'date'

config = ParseConfig.new('/var/solardb/etl.conf')
db = Mongo::Client.new(["#{config['DB_HOST']}:#{config['DB_PORT']}"], :database => config['DB_NAME'])

# 
# puts "date;temperature;humidity;windSpeed;cloudCover;production"
# productions = db[:production].find()
# for weather in db[:weather].find() do
#     production = 0
#     day = weather['date']
#     prods = productions.select do |prod| prod['date'] == "#{day.strftime("%m")}/#{day.strftime("%d")}/#{day.strftime("%Y")}" end
#     production = prods.first['production'] if prods.length > 0
#     puts "#{day};#{weather['temperature']};#{weather['humidity']};#{weather['windSpeed']};#{weather['cloudCover']};#{production}"
# end





# dateStart = Date.parse("01/01/2015")
# dateEnd = Date.today
#
# db[:weather].delete_many({})
#
# for date in dateStart...dateEnd do
#     sunshine = parseSunshineRate(config['MCCITY'], date)
#     temperature, humidity, windSpeed, cloudCover, classe = parseWeather(date)
#     weather = Weather.new(date, temperature, humidity, windSpeed, cloudCover, sunshine, classe)
#     db[:weather].insert_one(weather.to_json)
# end
